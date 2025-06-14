# frozen_string_literal: true

class SystemChatMessageComponentPreview < ViewComponent::Preview
  def default
    render SystemChatMessageComponent.new(
      msg: "Hello! I'm an AI assistant. How can I help you today?",
      llm_model: "GPT-4"
    )
  end

  def long_message
    render SystemChatMessageComponent.new(
      msg: "This is a longer message that demonstrates how the component handles multiple lines of text. It includes some technical details about the system and how it processes information.",
      llm_model: "Claude 3"
    )
  end

  def with_code
    render SystemChatMessageComponent.new(
      msg: "Here's a code example:\n\n```ruby\ndef hello_world\n  puts 'Hello, World!'\nend\n```",
      llm_model: "Gemini 2.5 Flash"
    )
  end
end 