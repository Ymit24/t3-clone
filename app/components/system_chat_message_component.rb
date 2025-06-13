# frozen_string_literal: true

class SystemChatMessageComponent < ViewComponent::Base
  def initialize(msg:, llm_model:)
    @msg = msg
    @llm_model = llm_model
  end
end
