# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  up do
    extension(:constraint_validations)
  end
  change do
    create_join_table(account_id: :accounts, event_id: :events) do
      # TODO: role column still does not exist
      String :role, null: false, default: 'attendee'

      add_constraint(:valid_role) do
        role.in(%w[attendee staff organizer])
      end
    end
  end
end
