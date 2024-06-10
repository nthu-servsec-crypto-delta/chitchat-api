# frozen_string_literal: true

module ChitChat
  # Service object to create a new project for an owner
  class CreatePostitForEvent
    class ForbiddenError < StandardError; end

    def self.call(account:, event:, postit_data:)
      # make sure the acount is in the event
      policy = EventPolicy.new(account, event)

      raise ForbiddenError unless policy.can_create_postit?

      postit = Postit.new(postit_data)
      account.add_owned_postit(postit)
      event.add_postit(postit)

      postit
    end
  end
end
