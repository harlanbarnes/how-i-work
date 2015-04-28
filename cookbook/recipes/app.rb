#
# Author:: Harlan Barnes (<hbarnes@pobox.com>)
# Cookbook Name:: simple
# Recipe:: app
#
# Installs nginx to serve up the static site
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

include_recipe 'simple::_security'

include_recipe 'apt::default'

package 'git'

directory '/root/.ssh' do
  mode '0700'
  recursive true
  action :create
end

cookbook_file '/root/.ssh/config' do
  source 'ssh_config'
  mode '0600'
  backup false
  action :create
end

directory node['app']['root'] do
  recursive true
  action :create
end

git node['app']['root'] do
  repository 'https://github.com/harlanbarnes/how-i-work.git'
  revision 'master'
  action :sync
end

include_recipe 'simple::_nginx'

template "#{node['nginx']['dir']}/sites-available/simple-site" do
  group node['root_group']
end

nginx_site 'simple-site' do
  enable true
end

include_recipe 'simple::_nrpe'

nrpe_check "check_simple_site" do
  command "#{node['nrpe']['plugin_dir']}/check_http"
  parameters "-H localhost -p #{node['app']['port']}"
  action :add
end
