#
# Author:: Harlan Barnes (<hbarnes@pobox.com>)
# Cookbook Name:: simple
# Recipe:: _nrpe
#
# The common parts of the nrpe setup
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

include_recipe 'nrpe::default'

remote_file "#{node['nrpe']['plugin_dir']}/check_mem" do
  source 'https://raw.githubusercontent.com/justintime/nagios-plugins/master/check_mem/check_mem.pl'
  mode '0755'
  backup false
end

nrpe_check "check_load" do
  warning_condition 2
  critical_condition 4
  action :add
end

nrpe_check "check_mem" do
  warning_condition 90
  critical_condition 95
  action :add
end

nrpe_check "check_disk" do
  warning_condition 90
  critical_condition 95
  action :add
end

nrpe_check "check_time" do
  parameters "-H 0.ubuntu.pool.ntp.org"
  warning_condition 5
  critical_condition 10
  action :add
end

nrpe_check "check_ssh" do
  parameters "localhost"
  action :add
end


