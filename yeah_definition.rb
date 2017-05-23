#
# Author:: Earth U (<sysadmin@chromedia.com>)
# Cookbook Name:: backup-file2s3
# Definition :: aws_tar_extract
#
# Copyright 2016, Chromedia Far East, Inc.
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

# Gets a tarball from AWS S3, then unpack it into a directory.
# Parameters:
#   :name | :file => The name of the backup tarball, without the extension
#   :target_dir   => Where the tarball is to be unpacked. If not
#                    exists, it will be created
#   :creates      => A file path used for idempotency
#   :region       => (Optional) AWS region. Defaults to node attribute.
#   :bucket       => (Optional) AWS bucket. Defaults to node attribute.
#   :encrypted    => (Optional) Boolean. Whether backup files are encrypted.
#   :priv_key     => (Optional) String. Contents of private key, if used.

define :aws_tar_extract,
       :file       => nil, # default is params[:name]
       :region     => nil,
       :bucket     => nil,
       :target_dir => nil,
       :creates    => nil,
       :encrypted  => false,
       :priv_key   => nil do

  fname    = params[:file] || params[:name]
  region   = params[:region] || node['backup-file2s3']['region']
  bucket   = params[:bucket] || node['backup-file2s3']['bucket']
  priv_key = params[:priv_key] || node['backup-file2s3']['encrypt']['priv_key']
  tmp_dir  = ::File.join(Chef::Config[:file_cache_path], 'f2s3_backups')

  include_recipe 'awscli'
  include_recipe 'tar'

  unless ::File.exist?(params[:creates])

    directory(tmp_dir) { recursive true }
    directory(params[:target_dir]) { recursive true }

    file_priv_key = "#{tmp_dir}/priv.key"
    fname_tgz     = "#{tmp_dir}/#{fname}.tar.gz"
    fname_path    = "#{tmp_dir}/#{fname}.tar.gz"

    if params[:encrypted]
      fname_path << '.enc'

      file file_priv_key do
        content   priv_key
        mode      0600
        sensitive true
      end

      execute "decrypt_#{fname}" do
        command  "openssl smime -decrypt -binary -inkey #{file_priv_key} "\
                 "-in #{fname_path} -out #{fname_tgz} -inform DEM"
        notifies :delete, "file[#{fname_path}]"
        notifies :delete, "file[#{file_priv_key}]"
        action   :nothing
      end

      file(fname_path) { action :nothing }
    end

    awscli_s3_file fname_path do
      region region
      bucket bucket
      key    "#{fname}/#{::File.basename(fname_path)}"
      if params[:encrypted]
        notifies :run, "execute[decrypt_#{fname}]", :immediately
      end
    end

    tar_extract fname_tgz do
      action     :extract_local
      target_dir params[:target_dir]
      creates    params[:creates]
      notifies   :delete, "file[#{fname_tgz}]"
    end

    file(fname_tgz) { action :nothing }
  end
end
