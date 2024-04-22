require 'json'

require 'sequel'

module ChitChat
  # Event Model
  class Event < Sequel::Model
    plugin :timestamps

    def to_json(options = {})
      JSON(
        {
          id:, name:, description:, location:
        },
        options
      )
    end
  end
end