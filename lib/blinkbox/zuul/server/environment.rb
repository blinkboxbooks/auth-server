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

        configure do
          I18n.config.enforce_available_locales = true

          properties = JavaProperties::Properties.new(REF_PROPFILE)
          properties.load(APP_PROPFILE) if File.exists? APP_PROPFILE

          set :properties, properties

          raise RuntimeError, "Keys folder does not exist at #{settings.properties[:'auth.keysPath']}" unless File.directory? settings.properties[:'auth.keysPath']

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