# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Account Handling' do
  include Rack::Test::Methods

  before do
    header 'Content-Type', 'application/json'
    wipe_database
  end

  describe 'Account information' do
    it 'HAPPY: should be able to get details of a single account' do
      account_data = DATA[:accounts][1]
      account = ChitChat::Account.create(account_data)

      header 'AUTHORIZATION', auth_header(account_data)
      get "/api/v1/accounts/#{account.username}"
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)['data']['attributes']
      account_data = result['account']['attributes']
      _(account_data['username']).must_equal account.username
      _(account_data['salt']).must_be_nil
      _(account_data['password']).must_be_nil
      _(account_data['password_hash']).must_be_nil
      _(result['auth_token']).wont_be_nil
    end
  end

  describe 'Account Creation' do
    before do
      @account_data = DATA[:accounts][1]
    end

    it 'HAPPY: should be able to create new accounts' do
      post 'api/v1/accounts', SignedRequest.new(app.config).sign(@account_data).to_json
      _(last_response.status).must_equal 201
      _(last_response.headers['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['attributes']
      account = ChitChat::Account.first

      _(created['username']).must_equal @account_data['username']
      _(created['email']).must_equal @account_data['email']
      _(account.password?(@account_data['password'])).must_equal true
    end

    it 'BAD: should not create account with illegal attributes' do
      bad_data = BAD_ACCOUNT
      post 'api/v1/accounts', SignedRequest.new(app.config).sign(bad_data).to_json

      _(last_response.status).must_equal 400
      _(last_response.headers['Location']).must_be_nil
    end

    it 'BAD: should sign request when creating account' do
      post 'api/v1/accounts', @account_data.to_json

      _(last_response.status).must_equal 403
      _(last_response.headers['Location']).must_be_nil
    end
  end
end
