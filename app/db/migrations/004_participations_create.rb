# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:participations) do
      primary_key :id

      foreign_key :event_id, :events, null: false
      foreign_key :account_id, :accounts, null: false
      TrueClass :approved, null: false, default: true
    end
  end
end
