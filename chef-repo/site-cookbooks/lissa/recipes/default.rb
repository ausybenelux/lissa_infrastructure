#
# Cookbook Name:: lissa
# Recipe:: default
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

# Make sure our packages are up to date
e = execute "apt-get update" do
  action :nothing
end
e.run_action(:run)

include_recipe 'git'
include_recipe 'curl'
include_recipe 'vim'

node.override['openssh']['server'].allow_agent_forwarding   = "yes"
node.override['openssh']['server'].allow_tcp_forwarding     = "no"
node.override['openssh']['server'].client_alive_count_max   = 0
node.override['openssh']['server'].client_alive_interval    = 600
node.override['openssh']['server'].ignore_user_known_hosts  = "yes"
node.override['openssh']['server'].login_grace_time         = "30s"
node.override['openssh']['server'].password_authentication  = "no"
node.override['openssh']['server'].permit_root_login        = "no"
node.override['openssh']['server'].rsa_authentication       = "no"

include_recipe 'openssh'
include_recipe 'chef-client::delete_validation'

ssh_known_hosts_entry 'github.com'

# Add local host names.
if node.has_key?(:vagrant_nodes)
  node.vagrant_nodes.each do |host_name, host|
    hostsfile_entry host['ip'] do
      hostname host["hostname"] + '.' + node.domain
      action :create
    end
  end
end
