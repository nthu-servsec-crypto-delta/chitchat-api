# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(event_id: :events, co_organizer_id: :accounts)
  end
end
