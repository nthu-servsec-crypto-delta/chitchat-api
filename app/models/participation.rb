# frozen_string_literal: true

require 'json'
require 'sequel'

module ChitChat
  # Event Model
  class Participation < Sequel::Model
    many_to_many :accounts, class: :'ChitChat::Account', key: :account_id
    many_to_many :events, class: :'ChitChat::Event', key: :event_id

    def to_json(options = {})
      JSON(
        {
          role:
        },
        options
      )
    end
  end
end
