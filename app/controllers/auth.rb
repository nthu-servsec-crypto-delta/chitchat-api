# frozen_string_literal: true

require 'roda'
require_relative 'app'
require_relative '../services/validate_registration'
require_relative '../services/send_registration_email'

module ChitChat
  # Web controller for Credence API
  class Api < Roda
    route('auth') do |routing|
      # All requests in this route require signed requests
      begin
        @request_data = SignedRequest.new(Api.config).parse(request.body.read)
      rescue SignedRequest::VerificationError
        routing.halt '403', { message: 'Must sign request' }.to_json
      end

      routing.is 'register' do
        # POST /api/v1/auth/register
        routing.post do
          ValidateRegistration.new(@request_data).call
          SendRegistrationEmail.new(@request_data).call

          response.status = 202
          Api.logger.info("Registration email sent to #{@request_data[:email]}")
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
          auth_account = AuthenticateAccount.call(@request_data)
          auth_account.to_json
        rescue AuthenticateAccount::UnauthorizedError
          routing.halt '403', { message: 'Invalid credentials' }.to_json
        end
      end

      routing.on 'sso' do
        routing.is 'github' do
          # POST /api/v1/auth/sso/github
          routing.post do
            code = @request_data[:code]
            auth_account = GitHubOAuthAccount.new(Api.config).call(code)
            auth_account.to_json
          rescue GitHubOAuthAccount::UnauthorizedError => e
            routing.halt '403', { message: e.message }.to_json
          rescue StandardError => e
            Api.logger.error "Could not authenticate with GitHub: #{e.inspect}"
            Api.logger.error e.backtrace.join("\n")
            routing.halt 500, { message: 'Server Error' }.to_json
          end
        end
      end
    end
  end
end
