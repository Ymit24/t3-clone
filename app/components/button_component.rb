# app/components/button_component.rb
class ButtonComponent < ViewComponent::Base
  # Initialize with new parameters
  # @param text [String, nil] The text content of the button.
  # @param icon [String, nil] The name of the Heroicon (e.g., "arrow-right").
  # @param icon_position [Symbol] :left or :right. Default is :left.
  # @param variant [Symbol] :primary, :secondary, :danger. Default is :primary.
  # @param type [Symbol] :button, :submit, :reset. Default is :button.
  # @param path [String, nil] The URL path for the button (if it's a link).
  # @param method [Symbol, nil] The HTTP method for the link (e.g., :delete for destroy actions).
  # @param confirm [String, nil] The confirmation message for Turbo (e.g., "Are you sure?").
  # @param data [Hash] Optional data attributes for Stimulus etc.
  def initialize(
    text: nil,
    icon: nil,
    icon_position: :left,
    variant: :primary,
    type: :button,
    path: nil,
    method: nil,
    confirm: nil,
    data: {}
  )
    @text = text
    @icon = icon
    @icon_position = icon_position
    @variant = variant
    @type = type
    @path = path
    @method = method
    @confirm = confirm
    @data = data
  end

  private

  # Helper method to check if the button contains only an icon.
  def icon_only?
    @icon.present? && @text.blank?
  end

  # Defines common base classes for all buttons.
  def base_classes
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

  # Helper method to determine if the button is a link.
  def link?
    @path.present?
  end

  # Combines data attributes for the button or link.
  def combined_data
    @data.merge({
      turbo_method: @method,
      turbo_confirm: @confirm
    }.compact)
  end
end
