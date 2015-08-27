require_relative 'base_driver'

module Ariranha
  module Drivers
    class Postgresql < BaseDriver
      def database
        pgsql_database
      end

      private

      attr_reader :pgsql_database, :pgsql_host, :pgsql_user, :pgsql_password

      def config_driver
        config.each do |k, v|
          instance_variable_set("@pgsql_#{k}".to_sym, v)
        end
      end

      def backup_cmd
        envs = {}
        envs['PGPASSWORD'] = pgsql_password if pgsql_password
        cmd = 'pg_dump -Fc --no-acl --no-owner '
        cmd += "--host=#{pgsql_host} " if pgsql_host
        cmd += "--username=#{pgsql_user} " if pgsql_user
        cmd += "#{pgsql_database} > /tmp/#{filename}"
        [envs, cmd]
      end

      def filename
        "#{pgsql_database}-#{timestamp}.dump"
      end
    end
  end
end
