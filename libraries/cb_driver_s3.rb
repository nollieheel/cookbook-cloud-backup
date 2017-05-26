module CloudBackup
  class S3
    include CloudBackup::DriverCommon

    def initialize(name='default',
                   script_dir: '/opt/cloud-backup',
                   log_dir: '/var/log/cloud-backup',
                   opts: {})
      @name = name
      @script_dir = script_dir
      @log_dir = log_dir
      @opts = opts

      @pub_key_path = nil
      @priv_key_path = nil
    end

    def init_backup_enc(key: nil, path: nil)
      @pub_key_path = do_init_enc(@name, @script_dir, key, path, 'pub')
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
