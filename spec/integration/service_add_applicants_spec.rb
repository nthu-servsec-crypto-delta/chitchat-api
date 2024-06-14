# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Participant Handling' do
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
      auth = authorization(@account_data)

      ChitChat::AddApplicant.call(
        event: @event,
        auth:
      )
      _(@event.applicants.count).must_equal 1
      _(@event.applicants.first).must_equal @account
    end

    it 'BAD: should not add a application' do
      auth = authenticate(@account_data)

      _(proc {
      ChitChat::AddApplicant.call(
        event: @event,
        auth:
      )}).must_raise(ChitChat::AddApplicant::ForbiddenError)
    end
  end
end
