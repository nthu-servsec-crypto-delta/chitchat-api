# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, postits and events...'
    create_accounts
    create_events
    create_owned_postits
    add_co_organizers
    add_participants
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
DATA = {
  accounts: YAML.load_file("#{DIR}/accounts_seed.yml"),
  postits: YAML.load_file("#{DIR}/postits_seed.yml"),
  events: YAML.load_file("#{DIR}/events_seed.yml"),
  co_organizations: YAML.load_file("#{DIR}/co_organizations_seed.yml"),
  participations: YAML.load_file("#{DIR}/participations_seed.yml")
}.freeze

def create_accounts
  DATA[:accounts].each do |account_info|
    ChitChat::Account.create(account_info)
  end
end

def create_events
  DATA[:events].each do |event|
    ChitChat::Event.create(event)
  end
end

def create_owned_postits
  DATA[:postits].each do |postit|
    account = ChitChat::Account.first(username: postit['username'])
    postit.delete('username')
    p = ChitChat::Postit.create(postit)
    account.add_owned_postit(p)
  end
end

def add_co_organizers
  DATA[:co_organizations].each do |co_org|
    account = ChitChat::Account.first(username: co_org['username'])
    event = ChitChat::Event.first(name: co_org['eventname'])
    event.add_co_organizer(account)
  end
end

def add_participants
  DATA[:participations].each do |participant|
    account = ChitChat::Account.first(username: participant['username'])
    event = ChitChat::Event.first(name: participant['eventname'])
    approved = participant['approved']
    ChitChat::Participation.create(account_id: account.id, event_id: event.id, approved:)
  end
end
