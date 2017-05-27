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

#      def initialize(name, dirs: {}, bins: {},
#                     opts: {})
#        @name = name || 'default'
#
#        @dir_script = dirs[:script] || '/opt/cloud-backup'
#        @dir_log = dirs[:log] || '/var/log/cloud-backup'
#        @dir_tmp = dirs[:tmp] || '/tmp/cloud-backup'
#
#        @bin_tar = bins[:tar] || '/bin/tar'
#        @bin_aws = bins[:aws] || '/usr/local/bin/aws'
#
#        @opts = opts
#
#        @path_pub_key = nil
#        @path_priv_key = nil
#      end
#
#      def init_backup_enc(rc, key: nil, path: nil)
#        @path_pub_key = do_init_enc(rc, @name, @dir_script, key, path, 'pub')
#      end

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
