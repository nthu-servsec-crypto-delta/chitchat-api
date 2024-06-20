# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Authentication Routes' do
  include Rack::Test::Methods

  before do
    header 'Content-Type', 'application/json'
    wipe_database
  end

  describe 'Account Authentication' do
    before do
      @account_data = DATA[:accounts][1]
      @account = ChitChat::Account.create(@account_data)
    end

    it 'HAPPY: should authenticate valid credentials' do
      post 'api/v1/auth/authenticate', SignedRequest.new(app.config).sign(@account_data).to_json

      auth_account = JSON.parse(last_response.body)
      account = auth_account['attributes']['account']['attributes']
      _(last_response.status).must_equal 200
      _(account['username']).must_equal(@account_data['username'])
      _(account['email']).must_equal(@account_data['email'])
    end

    it 'BAD: should not authenticate invalid password' do
      credentials = { username: @account_data['username'],
                      password: 'fakepassword' }

      post 'api/v1/auth/authenticate', SignedRequest.new(app.config).sign(credentials).to_json
      result = JSON.parse(last_response.body)

      _(last_response.status).must_equal 403
      _(result['message']).wont_be_nil
      _(result['attributes']).must_be_nil
    end

    it 'BAD: should sign when authenicating' do
      post 'api/v1/auth/authenticate', @account_data.to_json
      result = JSON.parse(last_response.body)

      _(last_response.status).must_equal 403
      _(result['message']).wont_be_nil
      _(result['attributes']).must_be_nil
    end
  end
end
