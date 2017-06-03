#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Library:: cb_driverlib
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

module CloudBackup
  module DriverLib
    CB_NAME = 'cookbook-cloud-backup'
    TEMPLATE_SRC = 'cloud-backup-'
    PREF_SCRIPT = 'cb-'

    def get_script_path(pref)
      "#{@dir['script']}/#{PREF_SCRIPT}#{pref.downcase}_#{@name.gsub(' ', '-')}"
    end

    ## Just create the cloud backup shell script.
    ##
    def do_render_script(pref, templatevars, action, rc)
      templatevars[:paths]   = @paths
      templatevars[:dir_tmp] = @dir['tmp']
      templatevars[:bin_tar] = @bin['tar']

      templatevars[:is_encrypted] = !!@key_pub
      templatevars[:key_pub]      = @key_pub

      rt = Chef::Resource::Template.new(get_script_path(pref), rc)
      rt.source "#{TEMPLATE_SRC}#{pref.downcase}.erb"
      rt.cookbook CB_NAME
      rt.owner 'root'
      rt.group 'root'
      rt.mode 0400
      rt.variables templatevars
      rt.run_action action
    end

    ## Schedule the backup script in cron
    ##
    def do_cron_sched(pref, action, rc)
      sched = @backup_sched.split(' ')
      spath = get_script_path(pref)
      sname = ::File.basename(spath)

      rc = Chef::Resource::CronD.new(sname, rc)
      rc.command "bash #{spath} >> #{@dir['log']}/#{sname}.log 2>&1"
      rc.minute sched[0]
      rc.hour sched[1]
      rc.day sched[2]
      rc.month sched[3]
      rc.weekday sched[4]
      rc.mailto @backup_mailto
      rc.path '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
      rc.run_action action
    end

  end
end
