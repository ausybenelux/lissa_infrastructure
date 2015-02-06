#
# Cookbook Name:: lissa
# Recipe:: cachefilesd
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#
# Speeds up NFS on vagrant.
#

package "cachefilesd" do
  action :install
end

file "/etc/default/cachefilesd" do
  content <<-EOS
RUN=yes
  EOS
  action :create
  mode 0755
end