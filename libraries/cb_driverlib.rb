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
  CB_NAME = 'cookbook-cloud-backup'

  module DriverLib
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

    def script_template(rc)
    end
  end

end
