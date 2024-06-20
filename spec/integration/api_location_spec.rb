# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Co-organizer Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
    @account_data = DATA[:accounts][0]
    @account_data2 = DATA[:accounts][1]
    @account_data3 = DATA[:accounts][2]

    @account = ChitChat::Account.create(@account_data)
    @account2 = ChitChat::Account.create(@account_data2)
    @account3 = ChitChat::Account.create(@account_data3)

    @event = ChitChat::Event.create(DATA[:events][0])
    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Account location' do
    it 'HAPPY: should update account location' do
      header 'AUTHORIZATION', auth_header(@account_data)
      put "api/v1/accounts/#{@account.username}/location", { longitude: 10, latitude: 20 }.to_json
      _(last_response.status).must_equal 200
    end

    it 'HAPPY: should only return accounts in range' do
      header 'AUTHORIZATION', auth_header(@account_data)
      @account.add_owned_event(@event)
      @event.add_co_organizer(@account2)
      @event.add_co_organizer(@account3)
      @account.location = ChitChat::Location.new(longitude: 121.565414, latitude: 25.032969)
      @account2.location = ChitChat::Location.new(longitude: 121.565414, latitude: 25.032969)
      @account3.location = ChitChat::Location.new(longitude: 120.967484, latitude: 24.813829)

      get "api/v1/events/#{@event.id}/accounts"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data'].count).must_equal 2
    end

    it 'HAPPY: should not get accounts if user does not provide location' do
      header 'AUTHORIZATION', auth_header(@account_data)
      @account.add_owned_event(@event)
      @event.add_co_organizer(@account2)
      @event.add_co_organizer(@account3)
      @account2.location = ChitChat::Location.new(longitude: 121.565414, latitude: 25.032969)
      @account3.location = ChitChat::Location.new(longitude: 121.565414, latitude: 25.032969)

      get "api/v1/events/#{@event.id}/accounts"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data'].count).must_equal 0
    end
  end
end
