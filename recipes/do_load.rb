#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Recipe:: do_load
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

::Chef::Recipe.send(:include, CloudBackup)

attribs = node[cookbook_name]

dir_keys = "#{attribs['dir']['script']}/keys"

directory dir_keys do
  recursive true
  action :nothing
end.run_action(:create)

directory attribs['dir']['tmp'] do
  recursive true
  action :nothing
end.run_action(:create)

attribs['targets'].each do |t|
  tname = t[:id] || 'default'

  is_load = t.has_key?(:load) ? t[:load] : false

  priv_path = if t[:encrypt_priv_key]
    path_key = "#{dir_keys}/priv_#{tname.gsub(' ', '-')}.pem"

    file path_key do
      content   t[:encrypt_priv_key]
      mode      0600
      owner     'root'
      group     'root'
      sensitive true
      action    :nothing
    end.run_action(is_load ? :create : :delete)

    ruby_block 'notify_delete_priv_key' do
      block {}
      notifies :delete, "file[#{path_key}]", :delayed
    end

    path_key
  elsif t[:encrypt_priv_path]
    t[:encrypt_priv_path]
  else
    nil
  end

  t[:drivers].each do |drname, dr|
    inst = Driver.const_get(drname).new(
      tname,
      paths: t[:paths],
      vars: dr,
      dir: attribs['dir'],
      bin: attribs['bin']
    )

    #inst.key_pub = pub_path
    #inst.sched_script(is_backup ? :create : :delete, run_context)
  end

end
