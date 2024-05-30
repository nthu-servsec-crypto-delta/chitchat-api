# frozen_string_literal: true

module ChitChat
  class InvalidRegistrationError < StandardError; end

  # Service to validate registration
  class ValidateRegistration
    def initialize(registration_data)
      @registration_data = registration_data
    end

    def username_exists?(username)
      !Account.first(username:).nil?
    end

    def email_exists?(email)
      !Account.first(email:).nil?
    end

    def call
      raise InvalidRegistrationError, 'Username is already taken' if username_exists?(@registration_data[:username])
      raise InvalidRegistrationError, 'Email is already taken' if email_exists?(@registration_data[:email])
    end
  end
end
