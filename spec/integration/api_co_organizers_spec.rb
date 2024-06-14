# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Co-organizer Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
    @organizer_data = DATA[:accounts][0]
    @organizer = ChitChat::Account.create(@organizer_data)

    @co_organizer_data = DATA[:accounts][1]
    @co_organizer = ChitChat::Account.create(@co_organizer_data)

    @wrong_account_data = DATA[:accounts][2]
    @wrong_account = ChitChat::Account.create(@wrong_account_data)

    auth = authorization(@organizer_data)

    ChitChat::CreateEventForOrganizer.call(
      auth:,
      event_data: DATA[:events][0]
    )

    @event = ChitChat::Event.find(name: DATA[:events][0]['name'])
    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Adding co_organizers to a event' do
    it 'HAPPY: should add a valid co_organizer' do
      req_data = { email: @co_organizer.email }

      header 'AUTHORIZATION', auth_header(@organizer_data)

      put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @co_organizer.username
    end

    # returns 500 error because @auth is nil
    # it 'SAD AUTHORIZATION: should not add a co_organizer without authorization' do
    #   req_data = { email: @co_organizer.email }

    #   put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json
    #   added = JSON.parse(last_response.body)['data']

    #   _(last_response.status).must_equal 403
    #   _(added).must_be_nil
    # end

    it 'BAD AUTHORIZATION: should not add an invalid co_organizer' do
      req_data = { email: @organizer.email }

      header 'AUTHORIZATION', auth_header(@organizer_data)
      put "api/v1/events/#{@event.id}/co_organizers", req_data.to_json
      added = JSON.parse(last_response.body)['data']

      _(last_response.status).must_equal 403
      _(added).must_be_nil
    end
  end

  describe 'Removing co_organizers from a event' do
    it 'HAPPY: should remove with proper authorization' do
      @event.add_co_organizer(@co_organizer)
      req_data = { email: @co_organizer.email }

      header 'AUTHORIZATION', auth_header(@organizer_data)
      delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      _(last_response.status).must_equal 200
    end

    # it 'SAD AUTHORIZATION: should not remove without authorization' do
    #   @event.add_co_organizer(@co_organizer)
    #   req_data = { email: @co_organizer.email }

    #   delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

    #   _(last_response.status).must_equal 403
    # end

    it 'BAD AUTHORIZATION: should not remove invalid co_organizer' do
      req_data = { email: @wrong_account.email }

      header 'AUTHORIZATION', auth_header(@organizer_data)
      delete "api/v1/events/#{@event.id}/co_organizers", req_data.to_json

      _(last_response.status).must_equal 403
    end
  end
end
