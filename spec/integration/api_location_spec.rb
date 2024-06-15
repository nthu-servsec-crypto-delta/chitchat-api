# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Co-organizer Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
    @account_data = DATA[:accounts][0]
    @account = ChitChat::Account.create(@account_data)

    @event = ChitChat::Event.create(DATA[:events][0])
    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Account location' do
    it 'HAPPY: should update account location' do
      header 'AUTHORIZATION', auth_header(@account_data)
      put "api/v1/accounts/#{@account.username}/location", { longitude: 10, latitude: 20 }.to_json
      _(last_response.status).must_equal 200
    end

    it 'HAPPY: should remove a application' do
      header 'AUTHORIZATION', auth_header(@account_data)
    end
  end
end
