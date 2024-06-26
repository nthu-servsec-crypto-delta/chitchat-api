# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test events API' do
  before do
    wipe_database

    @account_data = DATA[:accounts][0]
    @another_account_data = DATA[:accounts][1]
    @yet_another_account_data = DATA[:accounts][2]
    @wrong_account_data = DATA[:accounts][3]

    @account = ChitChat::Account.create(@account_data)
    @another_account = ChitChat::Account.create(@another_account_data)
    @yet_another_account = ChitChat::Account.create(@yet_another_account_data)
    @wrong_account = ChitChat::Account.create(@wrong_account_data)

    header 'CONTENT_TYPE', 'application/json'

    @event = ChitChat::Event.create(DATA[:events][0])
    @account.add_owned_event(@event)
    @event.add_co_organizer(@another_account)
  end

  # This should return a list of accounts without location information
  describe 'Getting Account in Events' do
    # it 'HAPPY: should be able to get list of all accounts in the event' do
    #   header 'AUTHORIZATION', auth_header(@account_data)
    #   get "/api/v1/events/#{@event.id}/accounts"
    #   _(last_response.status).must_equal 200
    #   result = JSON.parse(last_response.body)
    #   _(result['data'].count).must_equal 2
    # end
  end
end
