#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Recipe:: default
#
# Copyright 2017, Earth U
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

include_recipe 'awscli'
include_recipe 'tar'

ids = node[cookbook_name]['targets'].map do |x|
  x[:id] ? x[:id] : 'default'
end
if ids.length != ids.uniq.length
  Chef::Application.fatal!('Duplicate or nonexistent values for id in targets.')
end

include_recipe "#{cookbook_name}::do_backup"
include_recipe "#{cookbook_name}::do_load"
