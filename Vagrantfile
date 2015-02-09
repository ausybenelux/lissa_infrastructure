#
# LISSA Vagrant configuration
#

domain = 'lissa.dev'

nodes = {
  "web" => {
    :hostname   => 'admin',
    :ip         => '192.168.56.141',
    :box        => 'hashicorp/precise64',
    :ram        => 4096,
    :cpus       => 2,
    :roles      => ['messagebus', 'worker', 'database', 'web'],
    :ports      => [
        { :guest => 5672, :host => 5672 },
        { :guest => 15672, :host => 15672 },
        { :guest => 80, :host => 8080 }
    ],
    :shares     => [ { :src => './', :tgt => '/var/www/' } ]
  }
}

Vagrant.configure("2") do |config|
  config.vagrant.host = :detect
  config.hostsupdater.remove_on_suspend = true
  config.ssh.forward_agent = true
  # Prevent private key generation.
  # config.ssh.insert_key = false
  # Fix NFS permission issues
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  nodes.each do |node_name, node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.host_name = node[:hostname] + '.' + domain

      node_config.vm.network "private_network", ip: node[:ip]
      if node[:ports]
        node[:ports].each do |port|
          node_config.vm.network "forwarded_port", guest: port[:guest], host: port[:host], auto_correct: true
        end
      end
      if node[:shares]
        node[:shares].each do |share|
          if share[:src] != '' && share[:tgt] != ''
            node_config.vm.synced_folder "#{share[:src]}", "#{share[:tgt]}", type: "nfs", id: share[:src] + "-" + share[:tgt],
                mount_options: ["rw", "vers=3", "tcp", "fsc" ,"actimeo=2"]
          end
        end
      end

      memory = node[:ram] ? node[:ram] : 256;
      cpus = node[:cpus] ? node[:cpus] : 1;

      node_config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.customize [
            'modifyvm', :id,
            '--name', node[:hostname],
            '--memory', memory.to_s,
            '--cpus', cpus.to_s
        ]
      end

      node_config.hostsupdater.aliases = node[:aliases]

      # Update the chef version we're using.
      # Make sure you have installed the vagrant omnibus plugin: vagrant plugin install vagrant-omnibus
      node_config.omnibus.chef_version = '11.16'

      # Provision the node(s)
      node_config.vm.provision :chef_solo do |chef|
        # chef.log_level = :debug

        # Pass the node data to Chef so it can use the static IPs.
        chef.json = {
          "vagrant_nodes" => nodes,
          "domain" => domain
        }

        chef.environments_path = "chef-repo/environments"
        chef.cookbooks_path = ["chef-repo/site-cookbooks","chef-repo/cookbooks"]
        chef.roles_path = "chef-repo/roles"

        chef.environment = "vagrant"

        # Add support for root ssh agent forwarding.
        chef.add_recipe("root_ssh_agent::env_keep")
        chef.add_recipe("root_ssh_agent::ppid")

        # Speeds up NFS shares
        chef.add_recipe("lissa::cachefilesd")

        chef.add_role("base")
        node[:roles].each do |role_name|
          chef.add_role(role_name)
        end
      end
    end
  end
end
