require 'open3'

module Ariranha
  module Drivers
    class BaseDriver
      def initialize(config)
        @config = config
        config_driver
        @timestamp = Time.now.getutc.strftime('%Y%m%d%H%M%S')
      end

      attr_reader :database

      def backup
        puts "running #{backup_cmd}..."
        _out, _err, _status = Open3.capture3 backup_cmd
        filename
      end

      private

      attr_reader :config, :filename, :timestamp
    end
  end
end
