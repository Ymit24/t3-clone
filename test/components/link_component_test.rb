# frozen_string_literal: true

require "test_helper"

class LinkComponentTest < ViewComponent::TestCase
  def test_renders_link_with_text_and_href
    rendered = render_inline(LinkComponent.new(text: "Back", path: "/chats"))

    assert_includes rendered.text, "Back"
    assert_includes rendered.to_html, 'href="/chats"'
    assert_includes rendered.to_html, "inline-flex"
  end
end
