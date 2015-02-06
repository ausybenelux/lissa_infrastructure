# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "your-user-name"
client_key               "#{current_dir}/your-user-name.pem"
validation_client_name   "lissa-validator"
validation_key           "#{current_dir}/lissa-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/your-organization"
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
cookbook_path            ["#{current_dir}/../chef-repo/cookbooks", "#{current_dir}/../chef-repo/site-cookbooks"]
roles_path ["#{current_dir}/../chef-repo/roles"]
# data_bags_path ["#{current_dir}/../chef-repo/roles"]
environments_path ["#{current_dir}/../chef-repo/environments"]
