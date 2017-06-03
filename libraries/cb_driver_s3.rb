#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Library:: cb_driver_s3
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

require File.join(File.dirname(__FILE__), 'cb_driver_base')

module CloudBackup
  module Driver
    class S3 < CloudBackup::Driver::Base

      def sched_script(action, rc)
        do_render_script(
          's3',
          {
            :bin_aws => @bin['aws'],
            :bucket  => @vars[:bucket],
            :region  => @vars[:region]
          },
          action, rc
        )
        do_cron_sched('s3', action, rc)
      end

    end
  end
end
