# frozen_string_literal: true

class LlmPromptComponent < ViewComponent::Base
  def initialize(prompt:, llm_model:)
    @prompt = prompt
    @llm_model = llm_model
  end
end
