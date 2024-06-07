# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test events API' do
  before do
    wipe_database

    @account_data = DATA[:accounts][0]
    @another_account_data = DATA[:accounts][1]
    @wrong_account_data = DATA[:accounts][3]

    @account = ChitChat::Account.create(@account_data)
    @another_account = ChitChat::Account.create(@another_account_data)
    @wrong_account = ChitChat::Account.create(@wrong_account_data)

    header 'CONTENT_TYPE', 'application/json'

    DATA[:events].each do |event_data|
      ChitChat::CreateEventForOrganizer.call(
        organizer_id: @account.id,
        event_data:
      )
    end

    ChitChat::AddCoOrganizer.call(
      account: @account,
      event: ChitChat::Event.all[1],
      co_organizer_email: @another_account.email
    )
  end

  describe 'Getting Events' do
    it 'HAPPY: should be able to get list of all events' do
      header 'AUTHORIZATION', auth_header(@account_data)
      get '/api/v1/events/all'
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)
      _(result['data'].count).must_equal 4
    end

    it 'HAPPY: should be able to get list of allowed events' do
      header 'AUTHORIZATION', auth_header(@another_account_data)
      get '/api/v1/events'
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)
      _(result['data'].count).must_equal 1
    end
  end

  it 'HAPPY: should be able to get details of a single event' do
    event = ChitChat::Event.first
    get "/api/v1/events/#{event.id}"
    result = JSON.parse last_response.body

    _(last_response.status).must_equal 200
    _(result['attributes']['id']).must_equal event.id
  end

  it 'SAD: should return error if unknown event requested' do
    get '/api/v1/events/foobar'

    _(last_response.status).must_equal 404
  end

  it 'SECURITY: should return error if mass assignment attempted' do
    payload = MASS_ASSIGNMENT_EVENT.to_json
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    header 'AUTHORIZATION', auth_header(@account_data)
    post 'api/v1/events', payload, req_header

    _(last_response.status).must_equal 400
  end

  it 'SECURITY: should prevent SQL injection' do
    get '/api/v1/events/1%20or%201%3D1'

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new events' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    header 'AUTHORIZATION', auth_header(@account_data)
    post 'api/v1/events', DATA[:events][1].to_json, req_header

    _(last_response.status).must_equal 201
  end
end
