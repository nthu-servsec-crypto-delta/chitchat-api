# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test participation adding' do
  before do
    wipe_database
    @account = ChitChat::Account.create(DATA[:accounts][0])
    @account2 = ChitChat::Account.create(DATA[:accounts][1])

    @event = ChitChat::Event.create(DATA[:events][0])
    @event2 = ChitChat::Event.create(DATA[:events][1])
  end

  it 'HAPPY: should be able to see account in the same event' do
    @account.add_owned_event(@event)
    @event.add_participant(@account2)

    _(ChitChat::AccountPolicy.new(@account, @account2).can_view?).must_equal true
  end

  it 'SAD: should not be able to see account if not in same event' do
    @account.add_owned_event(@event)
    @account2.add_owned_event(@event2)

    _(ChitChat::AccountPolicy.new(@account, @account2).can_view?).must_equal false
  end
end
