#
# Cookbook Name:: lissa
# Recipe:: database
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#


# TODO: add secrets to encrypted chef data bags
node.default.mysql.server_root_password = 'root'
node.default.mysql.server_debian_password = 'root'
node.default['mysql']['allow_remote_root'] = false
node.default['mysql']['remove_anonymous_users'] = true
node.default['mysql']['root_network_acl'] = nil

include_recipe "mysql::client"
include_recipe "mysql::server"

cookbook_file '/etc/mysql/conf.d/lissa.cnf' do
  owner 'mysql'
  owner 'mysql'
  source 'lissa.cnf'
  notifies :restart, 'mysql_service[default]', :immediately
end
