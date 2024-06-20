# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module ChitChat
  # Main App
  class Api < Roda
    route('accounts') do |routing|
      @account_route = "#{@api_root}/accounts"
      routing.on String do |username|
        # GET api/v1/accounts/[username]
        routing.get do
          routing.halt(403, UNAUTH_MSG) unless @auth_account
          auth = AuthorizeAccount.call(
            auth: @auth,
            username:,
            auth_scope: AuthScope.new(AuthScope::READ_ONLY)
          )
          { data: auth }.to_json
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end

        routing.on('location') do
          # PUT api/v1/accounts/[username]/location
          routing.put do
            new_location = JSON.parse(routing.body.read)
            UpdateLocation.call(auth: @auth, location_data: new_location)
            { message: 'Location updated' }.to_json
          rescue StandardError => e
            routing.halt 500, { message: e.message }.to_json
          end
        end
      end

      # POST api/v1/accounts
      routing.post do
        account_data = SignedRequest.new(Api.config).parse(routing.body.read)
        new_account = Account.create(account_data)

        response.status = 201
        response['Location'] = "#{@account_route}/#{new_account.id}"
        { message: 'Account created', data: new_account }.to_json
      rescue Sequel::MassAssignmentRestriction
        Api.logger.warn "MASS-ASSIGNMENT:: #{account_data.keys}"
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue SignedRequest::VerificationError
        routing.halt 403, { message: 'Must sign request' }.to_json
      rescue StandardError
        Api.logger.error 'Unknown error saving account'
        routing.halt 500, { message: 'Error creating account' }.to_json
      end
    end
  end
end
