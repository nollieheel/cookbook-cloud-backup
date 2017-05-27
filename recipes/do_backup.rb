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

#directory "#{attribs['script_dir']}/keys" { recursive true }
#directory attribs['log_dir'] { recursive true }

attribs['targets'].each do |t|
  #testing
  s3 = Driver.const_get('S3').new(t[:id])
  s3.init_backup_enc(run_context, key: t[:encrypt_pub_key], path: t[:encrypt_pub_path])
end

#pub_key_file = "#{attribs['script_dir']}/pub.key"

#file pub_key_file do
#  content   attribs['encrypt']['pub_key']
#  mode      0600
#  owner     'root'
#  group     'root'
#  sensitive true
#  only_if   { is_any_enc }
#end

#attribs['backups'].each do |back|
#  snam   = back[:script_name] || 'default'
#  sname  = "#{snam.gsub(' ', '-')}_backup2s3"
#  enable = back.has_key?(:enable) ? back[:enable] : true
#
#  template "#{attribs['script_dir']}/#{sname}" do
#    mode   0644
#    source 'backup_file_to_s3.erb'
#    variables(
#      :aws_bin      => attribs['aws_bin'],
#      :tar_bin      => attribs['tar_bin'],
#      :tmp_dir      => attribs['tmp_dir'],
#      :bucket       => back[:bucket] || attribs['bucket'],
#      :region       => back[:region] || attribs['region'],
#      :pub_key_file => pub_key_file,
#      :paths        => back[:paths]
#    )
#    action( enable ? :create : :delete )
#  end
#
#  sched = attribs['cron']['sched'].split(' ')
#  cron_d sname do
#    command "bash #{attribs['script_dir']}/#{sname} >> "\
#            "#{attribs['log_dir']}/#{sname}.log 2>&1"
#    minute  sched[0]
#    hour    sched[1]
#    day     sched[2]
#    month   sched[3]
#    weekday sched[4]
#    mailto  attribs['cron']['mailto']
#    path    '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
#
#    action( enable ? :create : :delete )
#  end
#end
