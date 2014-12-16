require "sinatra/base"

module Sinatra
  module Blinkbox
    module LoggerContext

      module Util
        InterestingRequestHeaders = ["Accept-Encoding", "User-Agent" , "Via", "X-Forwarded-For", "X-Requested-With"]
        InterestingResponseHeaders = ["Cache-Control", "Content-Length", "WWW-Authenticate"]

        def self.headers(request, response)
          request_headers(request).merge(response_headers(response)).reject { |k, v| v.nil? }
        end

        private

        def self.request_headers(request)
          Hash[InterestingRequestHeaders.map { |h| [logging_name(h), request.env[rack_name(h)]] }]
        end

        def self.response_headers(response)
          Hash[InterestingResponseHeaders.map { |h| [logging_name(h), response.headers[h]] }]
        end

        def self.logging_name(header_name)
          "http" << header_name.gsub(/-/, "")
        end

        def self.rack_name(header_name)
          "HTTP_" << header_name.upcase.gsub(/-/, "_")
        end
      end

      def with_http_context(message, extra_context = {})
        {
          short_message: message,
          facilityVersion: VERSION,
          httpMethod: request.request_method,
          httpPath: request.path,
          httpPathAndQuery: request.path + request.query_string,        
          httpClientIP: request.ip,
          httpStatus: response.status
        }.merge(Util.headers(request, response)).merge(extra_context)
      end

    end
  end

  helpers ::Sinatra::Blinkbox::LoggerContext
end