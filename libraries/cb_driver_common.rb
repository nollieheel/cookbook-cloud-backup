module CloudBackup
  module DriverCommon
    def do_init_enc(name, script_dir, key, path, type)
      if key
        key_path = "#{script_dir}/keys/#{type}_#{name.gsub(' ', '-')}.pem"
        keys_dir = File.dirname(key_path)

        rd = Chef::Resource::Directory.new(keys_dir, run_context)
        rd.recursive true
        rd.run_action :create

        rf = Chef::Resource::File.new(key_path, run_context)
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
