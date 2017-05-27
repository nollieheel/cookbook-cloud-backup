#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Library:: cb_driver_common
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
  module DriverCommon
    def do_init_enc(rc, name, script_dir, key, path, type)
      if key
        key_path = "#{script_dir}/keys/#{type}_#{name.gsub(' ', '-')}.pem"
        keys_dir = File.dirname(key_path)

        rd = Chef::Resource::Directory.new(keys_dir, rc)
        rd.recursive true
        rd.run_action :create

        rf = Chef::Resource::File.new(key_path, rc)
        rf.mode 0600
        rf.owner 'root'
        rf.group 'root'
        rf.sensitive true
        rf.content key
        rf.run_action :create_if_missing

        key_path
      elsif path
        path
      else
        nil
      end
    end
  end
end
