# frozen_string_literal: true

require "test_helper"

class SystemChatMessageComponentTest < ViewComponent::TestCase
  def test_component_renders_message_and_model
    llm_model = llm_models(:one)
    msg = "System message!"
    rendered = render_inline(SystemChatMessageComponent.new(msg: msg, llm_model: llm_model))
    assert_text "System message!"
    assert_text llm_model.model
  end
end
