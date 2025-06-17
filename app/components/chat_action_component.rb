# frozen_string_literal: true

class ChatActionComponent < ViewComponent::Base
  def initialize(tag: :a, href: nil, icon: nil, color: nil, **other)
    @tag = tag || :link
    @href = href
    @icon = icon
    @color = color
    @other = other
  end
end
