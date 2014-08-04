require "sinatra/base"
require "active_record"
require "java_properties"
require "uri"
require "geoip"

module Blinkbox
  module Zuul
    module Server
      class App < Sinatra::Base

        REF_PROPFILE = File.join(__dir__,"../../../../config/reference.properties")
        APP_PROPFILE = File.join(__dir__,"../../../../config/application.properties")

        PROPERTIES_REQUIREMENTS = [
          {
            keys: %w{auth.keysPath},
            validity_test: proc { |p| File.directory? p[:'auth.keysPath'] },
            error: "Keys folder does not exist"
          },
          {
            keys: %w{database_url},
            validity_test: proc { |p| !p[:database_url].empty? },
            error: "Database URL is empty"
          }
        ]

        configure do
          I18n.config.enforce_available_locales = true

          properties = JavaProperties::Properties.new(REF_PROPFILE)
          properties.load(APP_PROPFILE) if File.exists? APP_PROPFILE

          invalid_reqs = PROPERTIES_REQUIREMENTS.map { |req|
            unless req[:validity_test].call(properties)
              req[:error] + " (#{req[:keys].join(', ')})"
            end
          }.compact

          if invalid_reqs.any?
            $stderr.puts "The application cannot start because of invalid properties:\n  #{invalid_reqs.join("\n  ")}\n"
            Process.exit(1)
          end

          $stderr.puts "Properties used:\n"
          properties.each do |key, value|
            $stderr.puts "  #{key} = #{value}"
          end

          set :properties, properties
          disable :show_exceptions, :dump_errors

          db = URI.parse(settings.properties[:database_url])
          ActiveRecord::Base.establish_connection(
            adapter: case db.scheme
                     when "mysql" then "mysql2"
                     when "postgres" then "postgresql"
                     else db.scheme
                     end,
            host: db.host,
            username: db.user,
            password: db.password,
            database: db.path[1..-1],
            encoding: "utf8",
            pool: 20
          )

          @@geoip = GeoIP.new(settings.properties[:geoip_data_file])

          Dir.glob(File.join(File.dirname(__FILE__), "models", "*.rb")).each { |file| require file }
          Dir.glob(File.join(File.dirname(__FILE__), "validators", "*.rb")).each { |file| require file }
        end

      end
    end
  end
end