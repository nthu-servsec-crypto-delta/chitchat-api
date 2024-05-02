# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:postits) do
      primary_key :id

      String :message_secure, null: false, default: ''
      String :location, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
