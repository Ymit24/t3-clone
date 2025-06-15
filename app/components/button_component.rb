# app/components/button_component.rb
class ButtonComponent < ViewComponent::Base
  # Initialize with new icon-related parameters
  # @param text [String, nil] The text content of the button.
  # @param icon [String, nil] The name of the Heroicon (e.g., "arrow-right").
  # @param icon_position [Symbol] :left or :right. Default is :left.
  # @param variant [Symbol] :primary, :secondary, :danger. Default is :primary.
  # @param type [Symbol] :button, :submit, :reset. Default is :button.
  def initialize(text: nil, icon: nil, icon_position: :left, variant: :primary, type: :button, data: {})
    @text = text
    @icon = icon
    @icon_position = icon_position
    @variant = variant
    @type = type
    @data = data
  end

  private

  # Helper method to check if the button contains only an icon.
  def icon_only?
    @icon.present? && @text.blank?
  end

  # Defines common base classes for all buttons.
  def base_classes
    # Adjusted padding: py-2 px-4 for text+icon/text-only.
    # We'll use p-2 for icon-only in the template.
    base = "rounded-md inline-flex items-center justify-center gap-2 font-medium transition-colors duration-200 focus:outline-none focus:ring-none disabled:opacity-50 disabled:cursor-not-allowed"

    # Apply padding based on content type
    if icon_only?
      "#{base} p-2 aspect-square" # Specific padding and aspect ratio for icon-only
    else
      "#{base} py-2 px-4" # Standard padding for buttons with text
    end
  end

  # Defines variant-specific classes.
  def variant_classes
    case @variant
    when :primary
      "bg-primary text-chat-area hover:bg-primary/90"
    when :secondary
      "bg-transparent border border-border text-text-primary hover:bg-sidebar"
    when :danger
      "bg-red-600 text-white hover:bg-red-700"
    else
      # Default to primary if an unknown variant is passed
      "bg-primary text-chat-area hover:bg-primary/90"
    end
  end

  # Combines all classes.
  def button_classes
    "#{base_classes} #{variant_classes}".strip
  end

  # Helper method to determine icon rendering.
  def render_icon?
    @icon.present?
  end

  # Helper method to determine text rendering.
  def render_text?
    @text.present?
  end
end
