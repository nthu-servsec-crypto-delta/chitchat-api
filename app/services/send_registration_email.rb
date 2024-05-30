# frozen_string_literal: true

require_relative '../lib/sendgrid'

module ChitChat
  # Service for sending registration email
  class SendRegistrationEmail
    def initialize(registration_data)
      @registration_data = registration_data
    end

    def mail_html
      <<~END_EMAIL
        <h1>ChitChat Registration Email Verification</h1>
        <p>Please <a href="#{@registration_data[:verification_url]}">click here</a> to validate your email.
        You will be asked to set a password to activate your account.</p>
      END_EMAIL
    end

    def call
      SendGrid.send(@registration_data[:email], 'ChitChat Registration Email Verification', mail_html)
    end
  end
end
