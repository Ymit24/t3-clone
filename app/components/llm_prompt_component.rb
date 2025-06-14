# frozen_string_literal: true

class LlmPromptComponent < ViewComponent::Base
  def initialize(message:)
    @message = message
  end
end
