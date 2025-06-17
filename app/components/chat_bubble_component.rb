# frozen_string_literal: true

class ChatBubbleComponent < ViewComponent::Base
  renders_one :body
  renders_many :actions, types: {
    link: lambda { |**args| ChatActionComponent.new(tag: :a, **args) },
    button: lambda { |**args| ChatActionComponent.new(tag: :button, **args) }
  }

  def initialize; end
end
