#
# Copyright 2014, CrossCheck
#
# All rights reserved - Do Not Redistribute
#

# Common
default['lissa']['domain'] = 'lissa.dev'

default['lissa']['known_hosts'] = [ 'github.com']
default['lissa']['user'] = ''

# Webserver
default['admin.lissa.dev']['server_name']   = node['hostname']
default['admin.lissa.dev']['drupal_root']   = '/var/www/admin-server/docroot'
