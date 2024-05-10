# frozen_string_literal: true

require 'sequel'
require 'json'

module ChitChat
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_postits, class: :'ChitChat::Postit', key: :owner_id
    plugin :association_dependencies, owned_postits: :destroy

    many_to_many :events, class: :'ChitChat::Event', key: :account_id

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
      self.password_digest = PasswordDigest.digest(new_password)
    end

    def password?(input)
      PasswordDigest.from_digest(password_digest).correct?(input)
    end
  end
end
