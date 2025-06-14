# frozen_string_literal: true

class SystemChatMessageComponent < ViewComponent::Base
  def initialize(id:, msg:, llm_model:)
    @id = id
    @msg = msg
    @llm_model = llm_model
  end
end
