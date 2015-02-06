#
# Cookbook Name:: lissa
# Recipe:: worker
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

pushstream_git_path = "#{Chef::Config['file_cache_path']}/nginx-push-stream-module"

git "#{pushstream_git_path}" do
  repository    "http://github.com/wandenberg/nginx-push-stream-module.git"
  revision      "master"
  reference     "master"
  action        :sync
  not_if { ::File.exists?(pushstream_git_path) }
end

node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['version'] = "1.6.0"
node.default['nginx']['source']['version'] = "1.6.0"
node.default['nginx']['source']['prefix'] = "/opt/nginx-#{node['nginx']['source']['version']}"
node.default['nginx']['source']['url'] = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
node.default['nginx']['source']['sbin_path'] = "#{node['nginx']['source']['prefix']}/sbin/nginx"
node.default['nginx']['source']['default_configure_flags'] = [
  "--prefix=#{node['nginx']['source']['prefix']}",
  "--conf-path=#{node['nginx']['dir']}/nginx.conf",
  "--sbin-path=#{node['nginx']['source']['sbin_path']}"
]
node.default['nginx']['configure_flags'] = node['nginx']['configure_flags'] | ["--add-module=#{pushstream_git_path}"]

include_recipe 'nginx::source'

cookbook_file "#{node.nginx.dir}/nginx.conf" do
  source "nginx.conf"
  mode "0644"
  owner node.nginx.user
  group node.nginx.user
end

cookbook_file "#{node.nginx.dir}/sites-available/push-stream.conf" do
  source "push-stream.conf"
  mode "0644"
  owner node.nginx.user
  group node.nginx.user
end

nginx_site "push-stream.conf"
nginx_site 'default' do
  enable false
  notifies :reload, 'service[nginx]'
end

cookbook_file "/etc/sysctl.conf" do
  source "sysctl.conf"
  mode "0644"
end


# Include the PHP worker

# Make sure we have a PHP version newer than 5.3.x, by default ubuntu 12.04 LTS
# doesn't have a package for 5.4 or higher.
include_recipe 'chef-dotdeb'
include_recipe 'chef-dotdeb::php54'
include_recipe 'php'
package "php5-curl" do
  action :install
end


git "/usr/local/share/lissa_worker" do
  repository    "git@github.com:ONEAgency/lissa_worker.git"
  revision      "master"
  reference     "master"
  action        :sync
end

# Add the local settings.
cookbook_file "/usr/local/share/lissa_worker/settings.local.php" do
  source    'worker_settings.local.php'
  mode      '0644'
  owner     node.nginx.user
  group     node.nginx.user
end

# Composer install overrides, make sure user web has permissions
node.override['composer']['global_configs'] = { "#{web_user}" => {} }
include_recipe 'composer'

composer_project "/usr/local/share/lissa_worker" do
    dev false
    quiet true
    prefer_dist false
    action :install
end


# Add supervisor to manage running the PHP worker.
node.default['python']['install_method'] = 'package'
include_recipe 'supervisor'

supervisor_service "lissa_worker" do
  command "php /usr/local/share/lissa_worker/worker.php"
end