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

    ## If encryption is enabled for backup/reload, create the key file
    ## (if needed), and put the key path in @key_pub/@key_priv.
    ##
    def do_init_enc(type, rc)
      symkey = "encrypt_#{type}_key".to_sym
      sympath = "encrypt_#{type}_path".to_sym

      if @target[symkey]
        key_dir = "#{@dir_script}/keys"
        rd = Chef::Resource::Directory.new(key_dir, rc)
        rd.recursive true
        rd.run_action :create

        key_path = "#{key_dir}/#{type}_#{@name.gsub(' ', '-')}.pem"
        rf = Chef::Resource::File.new(key_path, rc)
        rf.mode 0600
        rf.owner 'root'
        rf.group 'root'
        rf.sensitive true
        rf.content @target[symkey]
        rf.run_action :create_if_missing

        key_path
      elsif @target[sympath]
        @target[sympath]
      else
        nil
      end
    end

    ## Delete the (private) key file.
    ##
    def do_cleanup_enc(rc)
      if @key_priv
        #rf = Chef::Resource::Notification.new("", :delete)
        begin
          resources("file[#{@key_priv}]")
          rn = Chef::Resource::Notification.new("file[#{@key_priv}]", :delete)
        rescue Chef::Exceptions::ResourceNotFound
          rf = Chef::Resource::File.new(@key_priv, rc)
          rf.run_action :delete
        end
      end
    end

    def get_script_path(pref)
      "#{@dir_script}/#{pref}_#{@name.gsub(' ', '-')}"
    end

    ## Just create the cloud backup shell script.
    ##
    def do_render_script(pref, source, vars, action, rc)
      rt = Chef::Resource::Template.new(get_script_path(pref), rc)
      rt.source source
      rt.cookbook CB_NAME
      rt.owner 'root'
      rt.group 'root'
      rt.mode 0400
      rt.variables vars
      rt.run_action action
    end

    ## Schedule the backup script in cron
    ##
    def do_cron_sched(pref, action, rc)
      rd = Chef::Resource::Directory.new(@dir_log, rc)
      rd.recursive true
      rd.run_action :create

      bsched = @target[:backup_sched] || '0 0 * * *'
      bmailto = @target[:backup_mailto] || "''"
      sched = bsched.split(' ')
      spath = get_script_path(pref)
      sname = ::File.basename(spath)

      rc = Chef::Resource::CronD.new(sname, rc)
      rc.command "bash #{spath} >> #{@dir_log}/#{sname}.log 2>&1"
      rc.minute sched[0]
      rc.hour sched[1]
      rc.day sched[2]
      rc.month sched[3]
      rc.weekday sched[4]
      rc.mailto bmailto
      rc.path '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
      rc.run_action action
    end

  end
end
