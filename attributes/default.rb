#
# Author:: Earth U (<iskitingbords @ gmail.com>)
# Cookbook Name:: cookbook-cloud-backup
# Attribute:: default
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

# Contains details of files/directories to be backed up to cloud.
# Every element here will correspond to a different backup script.
default['cookbook-cloud-backup']['targets'] = [
#  {
#    :id => 'default', # default: 'default', but only
#                      #          one 'default' can exist at a time
#    :paths => [
#      {
#        :path            => '/var/sampledir',
#        :backup_filename => 'sampledir', # default: basename of path
#        :load_creates    => nil # file location, relative to path value
#      }
#    ],
#
#    :backup => true, # default: true
#    :backup_encrypted => false, # default: false
#    :backup_sched => nil, # default: '0 0 * * *'
#    :backup_mailto => nil, # default: ''
#
#    :load => false, # default: false
#
#    :encrypt_pub_key => nil, # actual contents of key, if used
#    :encrypt_priv_key => nil, # actual contents of key, if used
#
#    :driver_vars => [] # overrides default values in the 'drivers'
#                       # array for each driver
#  }
]

default['cookbook-cloud-backup']['drivers'] = [
  {
    :s3 => {
      :enable => true,
      :bucket => nil,
      :region => nil
    }
  }
]

default['cookbook-cloud-backup']['script_dir'] = '/opt/cloud-backup'
default['cookbook-cloud-backup']['log_dir']    = '/var/log/cloud-backup'
default['cookbook-cloud-backup']['tmp_dir']    = '/tmp/cloud-backup'

# Constants
default['cookbook-cloud-backup']['tar_bin'] = '/bin/tar'
default['cookbook-cloud-backup']['aws_bin'] = value_for_platform(
  'ubuntu'  => { 'default' => '/usr/local/bin/aws' },
  'default' => '/usr/local/bin/aws' # haven't tested on other platforms yet
)
