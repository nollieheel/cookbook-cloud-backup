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
      TEMPLATE_SRC = 'cloud-backup-s3.erb'

      def do_script_template(rc)
        spath = "#{@dir_script}/cb-s3_#{@name.gsub(' ', '-')}"
        rt = Chef::Resource::Template.new(spath, rc)
        rt.source TEMPLATE_SRC
        rt.cookbook CB_NAME
        rt.owner 'root'
        rt.group 'root'
        rt.mode 0400
        rt.variables(
        )
        rt.run_action :create
      end

    end
  end
end
