# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Authentication Routes' do
  include Rack::Test::Methods

  before do
    @req_header = { 'CONTENT_TYPE' => 'application/json' }
    wipe_database
  end

  describe 'Account Authentication' do
    before do
      @account_data = ACCOUNTS_DATA[1]
      @account = ChitChat::Account.create(@account_data)
    end

    it 'HAPPY: should authenticate valid credentials' do
      credentials = { username: @account_data['username'],
                      password: @account_data['password'] }
      post 'api/v1/auth/authenticate', credentials.to_json, @req_header

      auth_account = JSON.parse(last_response.body)
      _(last_response.status).must_equal 200
      _(auth_account['username']).must_equal(@account_data['username'])
      _(auth_account['email']).must_equal(@account_data['email'])

      # Should user id be returned by the authenticate api?
    end

    it 'BAD: should not authenticate invalid password' do
      credentials = { username: @account_data['username'],
                      password: 'fakepassword' }

      assert_output(/invalid/i, '') do
        post 'api/v1/auth/authenticate', credentials.to_json, @req_header
      end

      result = JSON.parse(last_response.body)

      _(last_response.status).must_equal 403
      _(result['message']).wont_be_nil
    end
  end
end
