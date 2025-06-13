# frozen_string_literal: true

class UserChatMessageComponent < ViewComponent::Base
  def initialize(msg:)
    @msg = msg
  end
end
