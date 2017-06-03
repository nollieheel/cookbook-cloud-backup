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

      attr_accessor :key_pub
      attr_accessor :key_priv

      def initialize(
        name,
        paths: nil,
        backup_sched: nil,
        backup_mailto: nil,
        dir: {}, bin: {}, vars: nil
      )
        @name  = name || 'default'
        @paths = paths || []

        @backup_sched  = backup_sched || '0 0 * * *'
        @backup_mailto = backup_mailto || "''"

        # Driver vars
        @vars = vars || {}

        # dirs and bins
        @dir = dir
        @bin = bin

        unless @dir.has_key?['script']
          @dir['script'] = '/opt/cloud-backup'
        end
        unless @dir.has_key?['log']
          @dir['log'] = '/var/log/cloud-backup'
        end
        unless @dir.has_key?['tmp']
          @dir['tmp'] = '/tmp/cloud-backup'
        end
        unless @bin.has_key?['tar']
          @bin['tar'] = '/bin/tar'
        end
      end

      ## Create the backup script and set cron schedule to run it.
      ##
      ## Example only. Override this method in Subclass.
      ##
      def sched_script(action, rc)
        do_render_script('none', {}, action, rc)
        do_cron_sched('none', action, rc)
      end

    end
  end
end
