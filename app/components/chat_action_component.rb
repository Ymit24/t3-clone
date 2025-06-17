# frozen_string_literal: true

class ChatActionComponent < ViewComponent::Base
  def initialize(tag: :a, icon: nil, color: nil, **other)
    @tag = tag || :link
    @icon = icon
    @color = color
    @other = other
  end
end
