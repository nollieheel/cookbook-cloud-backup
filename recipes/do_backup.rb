#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Recipe:: do_backup
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
directory dir_keys { recursive true }

directory attribs['dir']['log'] { recursive true }

attribs['targets'].each do |t|
  tname = t[:id] || 'default'

  is_backup = t.has_key?(:backup) ? t[:backup] : true
  is_load = t.has_key?(:load) ? t[:load] : false

  pub_path = 
    if t[:encrypt_pub_key]
      path_key = "#{dir_keys}/pub_#{tname.gsub(' ', '-')}.pem"

      file path_key do
        content   t[:encrypt_pub_key]
        mode      0600
        owner     'root'
        group     'root'
        sensitive true
        action    is_backup ? :create_if_missing : :delete
      end

      path_key
    elsif t[:encrypt_pub_path]
      t[:encrypt_pub_path]
    else
      nil
    end

  t[:drivers].each do |drname, dr|
    inst = Driver.const_get(drname).new(
      tname,
      paths: t[:paths],
      backup_sched: t[:backup_sched],
      backup_mailto: t[:backup_mailto],
      vars: dr,
      dir: attribs['dir'],
      bin: attribs['bin']
    )

    inst.key_pub = pub_path
    inst.sched_script(is_backup ? :create : :delete, run_context)
  end

#  if is_load
#    priv_path = 
#      if t[:encrypt_priv_key]
#        path_key = "#{dir_keys}/priv_#{tname.gsub(' ', '-')}.pem"

#        file path_key do
#          content   t[:encrypt_priv_key]
#          mode      0600
#          owner     'root'
#          group     'root'
#          sensitive true
#          action    :create_if_missing
#        end

#        path_key
#      elsif t[:encrypt_priv_path]
#        t[:encrypt_priv_path]
#      else
#        nil
#      end

#  end

end
