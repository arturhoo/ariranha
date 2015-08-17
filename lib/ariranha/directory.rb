require 'fog'

module Ariranha
  class Directory
    def initialize(adapter, config, backups_to_keep = 3)
      @fog_storage = Fog::Storage.new(
        "#{adapter.downcase}_access_key_id".to_sym => config['access_key'],
        "#{adapter.downcase}_secret_access_key".to_sym => config['secret_key'],
        provider: adapter)
      configure_fog_directory(config['directory'])
      @backups_to_keep = backups_to_keep
    end

    def upload(filename, parent_dir)
      puts "uploading #{filename}..."
      fog_directory.files.create(
        key: "#{parent_dir}/#{filename}",
        body: File.open("/tmp/#{filename}")
      )
      sorted_files = fog_directory.files.all(prefix: parent_dir + '/')
                     .reload.sort do |x, y|
        x.last_modified <=> y.last_modified
      end
      sorted_files[0..(-backups_to_keep - 1)].each(&:destroy)
    end

    private

    attr_reader :fog_storage, :fog_directory, :backups_to_keep

    def configure_fog_directory(directory_name)
      if fog_storage.directories.include?(directory_name)
        @fog_directory = fog_storage.directories.get(directory_name)
      else
        @fog_directory = fog_storage.directories.create(key: directory_name)
      end
    end
  end
end
