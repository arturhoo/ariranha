require_relative 'base_driver'

module Ariranha
  module Drivers
    class Mysql < BaseDriver
      def database
        mysql_database
      end

      private

      attr_reader :mysql_database, :mysql_host, :mysql_user, :mysql_password,
                  :mysql_ssl, :mysql_cert_path

      def config_driver
        config.each do |k, v|
          instance_variable_set("@mysql_#{k}".to_sym, v)
        end
      end

      def backup_cmd
        cmd = "mysqldump -u#{mysql_user} "
        cmd += "-p#{mysql_password} " if mysql_password
        cmd += "--ssl_ca=#{mysql_cert_path} " if mysql_ssl
        cmd + '--single-transaction --routines --triggers '\
              "-h #{mysql_host} #{mysql_database} "\
              "| gzip -c > /tmp/#{filename}"
      end

      def filename
        "#{mysql_database}-#{timestamp}.sql.gz"
      end
    end
  end
end
