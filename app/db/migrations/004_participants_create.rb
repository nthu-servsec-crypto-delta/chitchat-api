# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  up do
    extension(:constraint_validations)
  end
  change do
    create_table(:participants) do
      foreign_key :participant_id, :accounts
      foreign_key :event_id, :events

      primary_key [:participant_id, :event_id], name: :id

      String :role, null: false, default: 'attendee'

      add_constraint(:valid_role) do
        role.in(%w[attendee staff organizer])
      end
    end
  end
end
