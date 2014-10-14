require "sinatra/base"
require "rack/forward"
require "blinkbox/zuul/server/models/password_reset_token"
require "blinkbox/zuul/server/models/refresh_token"
require "blinkbox/zuul/server/models/user"

module Rack
  module Blinkbox
    module Zuul
      class SSOForward < Rack::Forward

        def initialize(app, delegate_server: nil, forwarded_domains: nil)
          @forwarded_domains = if forwarded_domains.strip == "*" then "*" else forwarded_domains.downcase.split(",").map { |d| d.strip } rescue [] end

          super(app) do |req|
            unless delegate_server.nil? || delegate_server.empty?
              # for authenticated requests we can check the user identifier
              is_forwarded = is_forwarded_user_id?(req.env["zuul.user_id"])

              # for unauthenticated requests we can tell from one of the parameters
              is_forwarded ||= is_forwarded_username?(req.params["username"]) ||
                              is_forwarded_refresh_token?(req.params["refresh_token"]) ||
                              is_forwarded_reset_token?(req.params["password_reset_token"])

              # redirect forwardeds to the delegate auth server
              if is_forwarded
                query_string = "?" + req.query_string unless req.query_string.empty?
                URI.parse("#{delegate_server}#{req.path_info}#{query_string}")
              end
            end
          end
        end

        def is_forwarded_reset_token?(token)
          reset_token = ::Blinkbox::Zuul::Server::PasswordResetToken.find_by_token(token) unless token.nil?
          !reset_token.nil? && is_forwarded?(reset_token.user)
        end

        def is_forwarded_refresh_token?(token)
          refresh_token = ::Blinkbox::Zuul::Server::RefreshToken.find_by_token(token) unless token.nil?
          !refresh_token.nil? && is_forwarded?(refresh_token.user)
        end

        def is_forwarded_username?(username)
          username_parts = if username.nil? then Array.new() else username.split("@") end
          @forwarded_domains == "*" || @forwarded_domains.include?(username_parts.last.downcase) rescue false
        end

        def is_forwarded_user_id?(user_id)
          user = ::Blinkbox::Zuul::Server::User.find_by_id(user_id) unless user_id.nil?
          is_forwarded?(user)
        end

        def is_forwarded?(user)
          !user.nil? && is_forwarded_username?(user.username)
        end

      end
    end
  end
end
