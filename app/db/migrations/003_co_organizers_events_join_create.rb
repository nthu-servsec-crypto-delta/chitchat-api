# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:co_organizers_events) do
      foreign_key :account_id, :accounts
      foreign_key :event_id, :events
      primary_key [:account_id, :event_id]
      index [:account_id, :event_id]
    end
  end
end
