# frozen_string_literal: true

require 'sequel'
require 'json'

module ChitChat
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_postits, class: :'ChitChat::Postit', key: :owner_id
    plugin :association_dependencies, owned_postits: :destroy

    one_to_many :participate_events, class: :'ChitChat::Participant', key: :id

    plugin :whitelist_security
    set_allowed_columns :username, :email, :password

    plugin :timestamps, update_on_create: true

    def to_json(options = {})
      JSON(
        {
          id:,
          username:,
          email:
        }, options
      )
    end

    def password=(new_password)
      self.password_digest = new_password
    end
  end
end
