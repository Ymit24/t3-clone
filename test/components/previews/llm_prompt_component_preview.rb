# frozen_string_literal: true

class LlmPromptComponentPreview < ViewComponent::Preview
  def default
    render LlmPromptComponent.new(
      prompt: "",
      llm_model: "gemini-2.5-flash"
    )
  end

  def with_existing_prompt
    render LlmPromptComponent.new(
      prompt: "Can you help me implement a feature that allows users to upload files?",
      llm_model: "gpt-4"
    )
  end

  def with_long_prompt
    render LlmPromptComponent.new(
      prompt: "I'm building a Rails application and I need to implement a complex feature that involves:\n\n1. File uploads\n2. Background processing\n3. Real-time updates\n4. Progress tracking\n\nCan you help me with the implementation?",
      llm_model: "claude-3"
    )
  end
end 