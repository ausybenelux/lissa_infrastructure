#
# Cookbook Name:: lissa
# Recipe:: drupal-distro
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

web_user = 'www-data'

# Create main admin server root dir
directory "#{Chef::Config[:file_cache_path]}/lissa_kickstart" do
  owner #{web_user}
  group #{web_user}
  mode  "0775"
  recursive true
end

# Create main admin server web dir
directory "#{node['admin.lissa.dev']['drupal_root']}" do
  owner #{web_user}
  group #{web_user}
  mode  "0777"
  recursive true
end

cookbook_file "#{Chef::Config[:file_cache_path]}/lissa_kickstart/build.properties" do
  source    'build.properties'
  mode      '0644'
  owner     #{web_user}
  group     #{web_user}
end

cookbook_file "#{Chef::Config[:file_cache_path]}/lissa_kickstart/settings.local.php" do
  source    'settings.local.php'
  mode      '0644'
  owner     #{web_user}
  group     #{web_user}
end