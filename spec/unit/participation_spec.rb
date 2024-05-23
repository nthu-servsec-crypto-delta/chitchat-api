# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test Participation Handling' do
  before do
    wipe_database

    DATA[:accounts].each do |account|
      ChitChat::Account.create(account)
    end

    DATA[:events].each do |event|
      ChitChat::Event.create(event)
    end
  end

  it 'HAPPY: should be able to add account to event' do
    account = ChitChat::Account.first
    event = ChitChat::Event.first

    event.add_account(account)
    _(event.accounts.include?(account)).must_equal true
  end

  it 'SAD: should not be able to add invalid role' do
    account = ChitChat::Account.first
    event = ChitChat::Event.first

    assert_raises(StandardError) do
      ChitChat::Participation.create(account_id: account.id, event_id: event.id, role: 'invalid_role')
    end

    _(event.accounts.include?(account)).must_equal false
  end
end
