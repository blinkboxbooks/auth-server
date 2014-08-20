require "sinatra/base"
require "rack/forward"
require "blinkbox/zuul/server/models/password_reset_token"
require "blinkbox/zuul/server/models/refresh_token"
require "blinkbox/zuul/server/models/user"

module Rack
  module Blinkbox
    module Zuul
      class SSOForward < Rack::Forward

        def initialize(app, delegate_server: nil)
          super(app) do |req|
            unless delegate_server.nil? || delegate_server.empty?
              # for authenticated requests we can check the user identifier
              is_employee = is_employee_user_id?(req.env["zuul.user_id"])

              # for unauthenticated requests we can tell from one of the parameters
              is_employee ||= is_employee_username?(req.params["username"]) ||
                              is_employee_refresh_token?(req.params["refresh_token"]) ||
                              is_employee_reset_token?(req.params["password_reset_token"])

              # redirect employees to the delegate auth server
              if is_employee
                query_string = "?" + req.query_string unless req.query_string.empty?
                URI.parse("#{delegate_server}#{req.path_info}#{query_string}")
              end
            end
          end
        end

        def is_employee_reset_token?(token)
          reset_token = ::Blinkbox::Zuul::Server::PasswordResetToken.find_by_token(token) unless token.nil?
          !reset_token.nil? && is_employee?(reset_token.user)
        end

        def is_employee_refresh_token?(token)
          refresh_token = ::Blinkbox::Zuul::Server::RefreshToken.find_by_token(token) unless token.nil?
          !refresh_token.nil? && is_employee?(refresh_token.user)
        end

        def is_employee_username?(username)
          !username.nil? && username.downcase.end_with?("@blinkbox.com")
        end

        def is_employee_user_id?(user_id)
          user = ::Blinkbox::Zuul::Server::User.find_by_id(user_id) unless user_id.nil?
          is_employee?(user)
        end

        def is_employee?(user)
          !user.nil? && is_employee_username?(user.username)
        end

      end
    end
  end
end