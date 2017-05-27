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

module CloudBackup
  module Driver
    class S3
      include CloudBackup::DriverCommon

      def initialize(name,
                     script_dir: '/opt/cloud-backup',
                     log_dir: '/var/log/cloud-backup',
                     opts: {})
        @name = name || 'default'
        @script_dir = script_dir
        @log_dir = log_dir
        @opts = opts

        @pub_key_path = nil
        @priv_key_path = nil
      end

      def init_backup_enc(rc, key: nil, path: nil)
        @pub_key_path = do_init_enc(rc, @name, @script_dir, key, path, 'pub')
      end

#      # Calling a chef resource:
#      r = Chef::Resource::Template.new('/home/ubuntu/stuff', run_context)
#      r.source 'stuff.erb'
#      r.cookbook 'mycookbook'
#      r.owner 'root'
#      r.group 'root'
#      r.mode '0400'
#      r.variables(
#        :var => 'dsad'
#      )
#      r.run_action :create

    end
  end
end
