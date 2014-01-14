require "blinkbox/zuul/server/errors"

module Blinkbox::Zuul::Server
  class User < ActiveRecord::Base

    class Role < ActiveRecord::Base
      has_one :user
      alias_attribute :name, :role
    end

    MIN_PASSWORD_LENGTH = 6

    has_many :refresh_tokens
    has_many :clients
    has_many :password_reset_tokens
    has_many :roles

    validates :first_name, length: { within: 1..50 }
    validates :last_name, length: { within: 1..50 }
    validates :username, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\Z/ }, uniqueness: true
    validates :allow_marketing_communications, inclusion: { :in => [true, false] }
    validates :password_hash, presence: true
    validate :validate_password

    after_create :report_user_created
    around_update :report_user_updated

    def name
      "#{first_name} #{last_name}"
    end

    def password=(password)
      if password
        @password_length = password.length
        self.password_hash = SCrypt::Password.create(password, max_time: 0.2, max_mem: 16 * 1024 * 1024)
      else
        @password_length = 0
        self.password_hash = ""
      end
    end

    def registered_clients
      clients.select { |client| !client.deregistered }
    end

    def self.authenticate(username, password, client_ip)
      return nil if username.nil? || password.nil?
      throttle_login_attempts(username)

      user = User.find_by_username(username)
      if user
        successful = SCrypt::Password.new(user.password_hash) == password
      else
        # even if the user isn't found we still need to perform an scrypt hash of something to help
        # prevent timing attacks as this hashing process is the bulk of the request time
        SCrypt::Password.create("random string")
        successful = false
      end
      
      LoginAttempt.new(username: username, successful: successful, client_ip: client_ip).save!
      successful ? user : nil
    end

    private

    def validate_password
      # this validation is only needed when the password is changed, in which case we recorded
      # the length of the new password in the accessor. if the password length attribute is nil
      # then the password hasn't been changed and we don't need to do the validation.
      if @password_length && @password_length < MIN_PASSWORD_LENGTH
        errors.add(:password, "is too short (minimum is #{MIN_PASSWORD_LENGTH} characters)")
      end
    end
    
    def report_user_created
      fields = %w{id username first_name last_name allow_marketing_communications}
      user = fields.each_with_object({}) do |field, hash|
        hash[field] = self[field]
      end
      Blinkbox::Zuul::Server::Reporting.user_registered(user)
    end

    def report_user_updated
      fields = %w{username first_name last_name allow_marketing_communications}
      affected_fields = self.changes.keys & fields
      if affected_fields.any?
        old_user, new_user = {}, {}
        fields.each do |field|
          old_user[field] = self.changes[field][0] rescue self[field]
          new_user[field] = self.changes[field][1] rescue self[field]
        end
        yield # saves
        Blinkbox::Zuul::Server::Reporting.user_updated(self["id"], old_user, new_user)
      else
        yield
      end
    end

    def self.throttle_login_attempts(username, max_attempts: 5, period: 20)
      recent_attempts = LoginAttempt.where(username: username)
                                    .where("created_at >= ?", Time.now.utc - period)
                                    .order(created_at: :desc)
                                    .limit(max_attempts)
      failed_attempts = recent_attempts.take_while { |attempt| !attempt.successful? }
      if failed_attempts.count == max_attempts
        failed_period = Time.now - failed_attempts.last.created_at
        error = TooManyRequests.new("Too many incorrect password attempts for '#{username}'")
        error.retry_after = period - failed_period
        raise error
      end
    end

  end
end
