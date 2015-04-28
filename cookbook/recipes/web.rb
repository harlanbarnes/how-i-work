#
# Author:: Harlan Barnes (<hbarnes@pobox.com>)
# Cookbook Name:: simple
# Recipe:: web
#
# Installs nginx as a proxy to web servers
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

include_recipe 'simple::_nginx'

template "#{node['nginx']['dir']}/sites-available/simple-proxy" do
  group node['root_group']
  notifies :reload, 'service[nginx]'
end

nginx_site 'simple-proxy' do
  enable true
end

include_recipe 'simple::_nrpe'

nrpe_check "check_simple_proxy" do
  command "#{node['nrpe']['plugin_dir']}/check_http"
  parameters "-H localhost -p 80"
  action :add
end
