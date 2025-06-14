# frozen_string_literal: true

require "test_helper"

class LlmPromptComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers

  def test_component_renders_form
    user = users(:one)
    llm_model = llm_models(:one)
    message = Message.new(user: user, llm_model: llm_model, value: "Hello")
    self.class.define_method(:message_path) { "/messages" }
    rendered = render_inline(LlmPromptComponent.new(message: message))
    assert_selector "form"
    assert_selector "textarea[placeholder='Type your message here...']"
  end
end
