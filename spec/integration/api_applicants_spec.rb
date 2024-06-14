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

  describe 'Adding applicants to a event' do
    it 'HAPPY: should add a application' do
      header 'AUTHORIZATION', auth_header(@account_data)

      put "api/v1/events/#{@event.id}/applicants", {}

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @account.username
    end

    it 'HAPPY: should remove a application' do
      @event.add_applicant(@account)

      header 'AUTHORIZATION', auth_header(@account_data)

      delete "api/v1/events/#{@event.id}/applicants", {}

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @account.username
    end
  end
end
