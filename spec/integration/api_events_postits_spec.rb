# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test postits API' do
  before do
    wipe_database

    @account_data = DATA[:accounts][0]
    @another_account_data = DATA[:accounts][1]

    @account = ChitChat::Account.create(@account_data)
    @another_account = ChitChat::Account.create(@another_account_data)

    ChitChat::CreateEventForOrganizer.call(
      organizer_id: @account.id,
      event_data: DATA[:events][0]
    )

    @event = ChitChat::Event.find(name: DATA[:events][0]['name'])

    ChitChat::CreatePostitForEvent.call(
      account: @account,
      event: @event,
      postit_data: DATA[:postits][0]
    )

    ChitChat::CreatePostitForEvent.call(
      account: @account,
      event: @event,
      postit_data: DATA[:postits][1]
    )
  end

  describe 'Getting list of postits' do
    it 'HAPPY: should get list for authorized account' do
      header 'AUTHORIZATION', auth_header(@account_data)
      get "api/v1/events/#{@event.id}/postits"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      # The serialization of postit.location requires result['data'] to be parsed again
      _(JSON.parse(result['data']).count).must_equal 2
    end

    it 'BAD: should not process for unauthorized account' do
      header 'AUTHORIZATION', auth_header(@another_account_data)
      get "api/v1/events/#{@event.id}/postits"
      _(last_response.status).must_equal 403

      result = JSON.parse(last_response.body)
      _(result['data']).must_be_nil
    end
  end

  it 'HAPPY: should be able to create new postits' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    header 'AUTHORIZATION', auth_header(@account_data)
    post "api/v1/events/#{@event.id}/postits", DATA[:postits][1].to_json, req_header

    _(last_response.status).must_equal 201
  end

  it 'SAD: should not be able to create new postits without correct authorization' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    header 'AUTHORIZATION', auth_header(@another_account_data)
    post "api/v1/events/#{@event.id}/postits", DATA[:postits][1].to_json, req_header

    _(last_response.status).must_equal 403
  end
end
