#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Library:: cb_driver_base
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

require File.join(File.dirname(__FILE__), 'cb_driverlib')

module CloudBackup
  module Driver
    class Base
      include CloudBackup::DriverLib

      def initialize(target, dirs: {}, bins: {})

        # dirs and bins
        @dir_script = dirs[:script] || '/opt/cloud-backup'
        @dir_log    = dirs[:log] || '/var/log/cloud-backup'
        @dir_tmp    = dirs[:tmp] || '/tmp/cloud-backup'

        @bin_tar = bins[:tar] || '/bin/tar'
        @bin_aws = bins[:aws] || '/usr/local/bin/aws'

        # default name
        @name   = target[:id] || 'default'

        # just store the node attribs
        @target = target

        # path to encryption keys if used
        @key_pub  = nil
        @key_priv = nil
      end

      ## Call this function before attempting any backup script creation.
      ##
      def init_backup_enc(rc)
        @key_pub = do_init_enc('pub', rc)
      end

      ## Call this function before attempting any reload of backups.
      ##
      def init_reload_enc(rc)
        @key_priv = do_init_enc('priv', rc)
      end

      ## Create the backup script and set cron schedule to run it.
      ##
      ## Example only. Override this method in Subclass.
      ##
      def sched_script(action, rc)
        do_render_script('cb-none', 'cloud-backup-none.erb', {}, action, rc)
        do_cron_sched('cb-none', action, rc)
      end

    end
  end
end
