# frozen_string_literal: true

require 'roda'
require_relative 'app'
require_relative 'services/validate_registration'
require_relative 'services/send_registration_email'

module ChitChat
  # Web controller for Credence API
  class Api < Roda
    route('auth') do |routing|
      routing.is 'register' do
        # POST /api/v1/auth/register
        routing.post do
          registration_data = JSON.parse(request.body.read, symbolize_names: true)
          ValidateRegistration.new(registration_data).call
          SendRegistrationEmail.new(registration_data).call

          response.status = 202
          Api.logger.info("Registration email sent to #{registration_data[:email]}")
          { message: 'Email sent' }.to_json
        rescue ValidateRegistration::InvalidRegistrationError => e
          routing.halt 400, { message: e.message }.to_json
        rescue SendRegistrationEmail::EmailError => e
          Api.logger.error("Registration email could not be sent: #{e.inspect}")
          routing.halt 500, { message: 'Registration email could not be sent' }.to_json
        rescue StandardError => e
          Api.logger.error("Count not validate registration: #{e.inspect}")
          routing.halt 500
        end
      end

      routing.is 'authenticate' do
        # POST /api/v1/auth/authenticate
        routing.post do
          credentials = JSON.parse(request.body.read, symbolize_names: true)
          auth_account = AuthenticateAccount.call(credentials)
          auth_account.to_json
        rescue AuthenticateAccount::UnauthorizedError
          routing.halt '403', { message: 'Invalid credentials' }.to_json
        end
      end
    end
  end
end
