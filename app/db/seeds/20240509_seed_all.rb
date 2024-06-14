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
  organizer_events: YAML.load_file("#{DIR}/organizer_events_seed.yml"),
  co_organizers: YAML.load_file("#{DIR}/co_organizers_seed.yml"),
  participants: YAML.load_file("#{DIR}/participants_seed.yml"),
  applicants: YAML.load_file("#{DIR}/applicants_seed.yml")
}.freeze

def create_accounts
  DATA[:accounts].each do |account_info|
    ChitChat::Account.create(account_info)
  end
end

def create_events
  DATA[:organizer_events].each do |organizer|
    account = ChitChat::Account.first(username: organizer['username'])
    organizer['eventname'].each do |eventname|
      event_data = DATA[:events].find { |event| event['name'] == eventname }
      event = ChitChat::Event.create(event_data)
      account.add_owned_event(event)
    end
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
  DATA[:co_organizers].each do |co_org|
    account = ChitChat::Account.first(username: co_org['username'])
    event = ChitChat::Event.first(name: co_org['eventname'])
    event.add_co_organizer(account)
  end
end

def add_participants
  DATA[:participants].each do |participant|
    account = ChitChat::Account.first(username: participant['username'])
    event = ChitChat::Event.first(name: participant['eventname'])
    event.add_participant(account)
  end
end

def add_applicants
  DATA[:applicants].each do |participant|
    account = ChitChat::Account.first(username: participant['username'])
    event = ChitChat::Event.first(name: participant['eventname'])
    event.add_applicant(account)
  end
end
