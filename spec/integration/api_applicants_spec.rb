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

    @event = ChitChat::Event.create(DATA[:events][0])
    @account.add_owned_event(@event)

    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Adding applicants to a event' do
    it 'HAPPY: should add a application' do
      header 'AUTHORIZATION', auth_header(@another_account_data)

      put "api/v1/events/#{@event.id}/applicants", {}

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @another_account.username
    end

    it 'HAPPY: should remove a application' do
      ChitChat::AddApplicant.call(
        event: @event,
        account: @another_account
      )

      header 'AUTHORIZATION', auth_header(@another_account_data)

      delete "api/v1/events/#{@event.id}/applicants", {}

      added = JSON.parse(last_response.body)['data']['attributes']

      _(last_response.status).must_equal 200
      _(added['username']).must_equal @another_account.username
    end
  end
end
