# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Co-organizer Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
    @account_data = DATA[:accounts][0]
    @another_account_data = DATA[:accounts][1]
    @wrong_account_data = DATA[:accounts][2]

    @account = ChitChat::Account.create(@account_data)
    @another_account = ChitChat::Account.create(@another_account_data)
    @wrong_account = ChitChat::Account.create(@wrong_account_data)

    ChitChat::CreateEventForOrganizer.call(
      organizer_id: @account.id,
      event_data: DATA[:events][0]
    )

    @event = ChitChat::Event.find(name: DATA[:events][0]['name'])
    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Adding co_organizers to a event' do
    it 'HAPPY: should add a valid co_organizer' do
      req_data = { email: @another_account.email }

      header 'AUTHORIZATION', auth_header(@account_data)

      put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @another_account.username
    end

    it 'SAD AUTHORIZATION: should not add a co_organizer without authorization' do
      req_data = { email: @another_account.email }

      put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json
      added = JSON.parse(last_response.body)['data']

      _(last_response.status).must_equal 403
      _(added).must_be_nil
    end

    it 'BAD AUTHORIZATION: should not add an invalid co_organizer' do
      req_data = { email: @account.email }

      header 'AUTHORIZATION', auth_header(@account_data)
      put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json
      added = JSON.parse(last_response.body)['data']

      _(last_response.status).must_equal 403
      _(added).must_be_nil
    end
  end

  describe 'Removing co_organizers from a event' do
    it 'HAPPY: should remove with proper authorization' do
      @event.add_co_organizer(@another_account)
      req_data = { email: @another_account.email }

      header 'AUTHORIZATION', auth_header(@account_data)
      delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      _(last_response.status).must_equal 200
    end

    it 'SAD AUTHORIZATION: should not remove without authorization' do
      @event.add_co_organizer(@another_account)
      req_data = { email: @another_account.email }

      delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      _(last_response.status).must_equal 403
    end

    it 'BAD AUTHORIZATION: should not remove invalid co_organizer' do
      req_data = { email: @another_account.email }

      header 'AUTHORIZATION', auth_header(@account_data)
      delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      _(last_response.status).must_equal 403
    end
  end
end
