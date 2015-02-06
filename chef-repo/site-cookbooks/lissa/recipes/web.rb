#
# Cookbook Name:: lissa
# Recipe:: web
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

app_name = 'admin.lissa.dev'
app_config = node.default[app_name]
web_user = node["web_user"];

# Create Drupal admin server root dir
directory app_config['drupal_root'] do
  owner #{web_user}
  group "www-data"
  mode  "0775"
  action :create
  recursive true
end

# TODO: move to attributes file??
node.override['apache'].allow_override    = "None"
node.override['apache'].contact           = "support@crosscheck.be"
node.override['apache'].default_modules   = [ "alias","cgi","deflate","dir","log_config","logio","mime","rewrite","setenvif" ]
node.override['apache'].default_site_enabled = false
node.override['apache'].directory_index   = "disabled"
node.override['apache'].directory_options = "None"
node.override['apache'].ext_status        = false
node.override['apache'].keepalive         = "Off"
node.override['apache'].keepaliverequests = "100"
node.override['apache'].keepalivetimeout  = "15"
node.override['apache'].listen_ports      = [ "80", "443" ]
node.override['apache'].serversignature   = "Off"
node.override['apache'].servertokens      = "Prod"
node.override['apache'].timeout           = "120"
node.override['apache'].traceenable       = "Off"
node.override['php']['directives']        = {:memory_limit => "512M"}

# Make sure we have a PHP version newer than 5.3.x, by default ubuntu 12.04 LTS
# doesn't have a package for 5.4 or higher.
include_recipe 'chef-dotdeb'
include_recipe 'chef-dotdeb::php54'

include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'php'
include_recipe "mysql::client"

package "php5-mysqlnd" do
  action :install
end

package "php5-gd" do
  action :install
end

package "php5-curl" do
  action :install
end

package "php5-apc" do
  action :install
end

# Composer install overrides, make sure user web has permissions
node.override['composer']['global_configs'] = { "#{web_user}" => {} }
include_recipe 'composer'

# Set up the Apache virtual host
web_app app_name do
  server_name   app_config['server_name']
  docroot       app_config['drupal_root']
  server_aliases [node['fqdn'], node['hostname']]
  template      "#{app_name}.conf.erb"
  log_dir       node['apache']['log_dir']
end

# Set up drush
node.override['drush'].version = "dev-master#6ad8c93"
include_recipe 'drush::composer'

# Set up Phing
include_recipe 'phing'

# Build the lissa_kickstart distribution.
include_recipe 'lissa::drupal-distro'
