# frozen_string_literal: true

require 'sequel'
require 'json'

module ChitChat
  # Models a registered account
  class Participant < Sequel::Model
    plugin :timestamps, update_on_create: true

    def to_json(options = {})
      JSON(
        {
          participant_id:,
          event_id:,
          role:
        }, options
      )
    end
  end
end
