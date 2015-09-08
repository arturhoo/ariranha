require_relative 'directory'
require_relative 'drivers/mysql'
require_relative 'drivers/postgresql'

module Ariranha
  class Base
    def initialize(config_file = 'config.yml')
      @config = YAML.load(File.open(config_file))
      config_instances
      config_directories
    end

    def backup
      instances.each do |instance|
        filename = instance.backup
        directories.each { |dir| dir.upload(filename, instance.database) }
        puts "deleting /tmp/#{filename}..."
        Open3.capture3 "rm -rf /tmp/#{filename}"
      end
    end

    private

    attr_reader :config, :instances, :directories

    def config_instances
      @instances = []
      config['databases'].each do |driver, instances|
        driver_str = "Ariranha::Drivers::#{driver.capitalize}"
        driver = driver_str.split('::').reduce(Object) { |a, e| a.const_get(e) }
        instances.each { |instance_cfg| @instances << driver.new(instance_cfg) }
      end
    end

    def config_directories
      @directories = []
      config['providers'].each do |provider, provider_cfg|
        @directories << Directory.new(provider, provider_cfg,
                                      config['keep_backups'])
      end
    end
  end
end
