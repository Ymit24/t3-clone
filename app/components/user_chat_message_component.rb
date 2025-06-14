# frozen_string_literal: true

class UserChatMessageComponent < ViewComponent::Base
  def initialize(msg:, llm_model:)
    @msg = msg
    @llm_model = llm_model
  end
end
