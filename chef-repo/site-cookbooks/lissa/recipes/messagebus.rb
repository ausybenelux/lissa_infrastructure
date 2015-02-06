#
# Cookbook Name:: lissa
# Recipe:: messagebus
#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_user "admin" do
  password "admin"
  action :add
end
