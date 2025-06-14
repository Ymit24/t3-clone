# frozen_string_literal: true

require "test_helper"

class UserChatMessageComponentTest < ViewComponent::TestCase
  def test_component_renders_message_and_model
    llm_model = llm_models(:one)
    msg = "User message!"
    rendered = render_inline(UserChatMessageComponent.new(msg: msg, llm_model: llm_model))
    assert_text "User message!"
    assert_text llm_model.name
  end
end
