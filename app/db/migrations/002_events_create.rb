# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :organizer_id, :accounts

      String :name
      String :description
      String :location, null: false
      String :radius, null: false
      DateTime :start_time, null: false
      DateTime :end_time, null: false
      TrueClass :needs_approval, default: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
