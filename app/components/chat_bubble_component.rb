# frozen_string_literal: true

class ChatBubbleComponent < ViewComponent::Base
  renders_one :body
  renders_one :info
  renders_many :actions, types: {
    link: lambda { |**args| ChatActionComponent.new(tag: :a, **args) },
    button: lambda { |**args| ChatActionComponent.new(tag: :button, **args) }
  }

  def initialize(is_system: false)
    @is_system = is_system
  end
end
