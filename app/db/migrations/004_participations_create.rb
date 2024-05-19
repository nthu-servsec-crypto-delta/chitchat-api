# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:participations) do
      primary_key :id

      foreign_key :event_id, :events, null: false
      foreign_key :account_id, :accounts, null: false

      String :role, null: false, default: 'attendee'

      check { role =~ %w[attendee staff organizer] }
    end
  end
end
