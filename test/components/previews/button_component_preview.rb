# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  layout "component_preview"

  def default
    render ButtonComponent.new(text: "Click me")
  end

  def secondary
    render ButtonComponent.new(text: "Secondary Button", variant: :secondary)
  end
end 