require 'fog'

module Ariranha
  class Directory
    ADAPTER_KEYS = {
      'AWS' => [:aws_access_key_id, :aws_secret_access_key],
      'Google' => [:google_storage_access_key_id,
                   :google_storage_secret_access_key]
    }

    def initialize(adapter, config, keep_backups = 3)
      @fog_storage = Fog::Storage.new(
        ADAPTER_KEYS[adapter][0] => config['access_key'],
        ADAPTER_KEYS[adapter][1] => config['secret_key'],
        provider: adapter)
      @adapter = adapter
      @fog_directory = configure_fog_directory(config['directory'])
      @keep_backups = keep_backups
    end

    def upload(filename, parent_dir)
      puts "uploading #{filename} to #{adapter}..."
      fog_directory.files.create(
        key: "#{parent_dir}/#{filename}",
        body: File.open("/tmp/#{filename}")
      )
      sorted_files = fog_directory.files.all(prefix: parent_dir + '/')
                     .reload.sort do |x, y|
        x.last_modified <=> y.last_modified
      end
      sorted_files[0..(-keep_backups - 1)].each(&:destroy)
    end

    private

    attr_reader :adapter, :fog_storage, :fog_directory, :keep_backups

    def configure_fog_directory(directory_name)
      fog_storage.directories.get(directory_name) ||
        fog_storage.directories.create(key: directory_name)
    end
  end
end
