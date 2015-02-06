# Author:: Mark Sonnabaum <mark.sonnabaum@acquia.com>
# Contributor:: Klaas Van Waesberghe <klaasvw@gmail.com>
# Cookbook Name:: drush
# Recipe:: composer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_recipe "composer"

case node[:platform]
when "debian", "ubuntu", "centos", "redhat"
  execute "install_drush_composer" do
    command "#{node['composer']['bin']} global require --no-interaction drush/drush:#{node['drush']['version']}"
    not_if "which drush"
  end

  ##############################################################################
  # In the bash script below we execute 'composer install' 2 times, the first
  # time to install drush to the correct directories. The second time to remove
  # the /usr/local/share/drush/drush/vendor/drush directory which is not needed.
  #
  # For security reasons one might want to chown and chmod /usr/local/bin/drush
  # so only authorized users in a certain group can execute drush.
  ##############################################################################
  bash "post_install_drush" do
    user 'root'
    cwd File.expand_path('~/.composer')
    code <<-EOH
      #{node['composer']['bin']} config --global bin-dir /usr/local/bin
      #{node['composer']['bin']} config --global vendor-dir /usr/local/share
      #{node['composer']['bin']} install
      cp -R vendor/ /usr/local/share/drush/drush/
      #{node['composer']['bin']} install
    EOH
    environment 'PREFIX' => '/usr/local'
  end

end
