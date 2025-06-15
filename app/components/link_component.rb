# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  # @param text [String] The text content of the link.
  # @param path [String] The URL path the link points to.
  # @param variant [Symbol] :default or :accent. Default is :default.
  # @param classes [String, nil] Additional custom Tailwind classes to add.
  # @param data [Hash] Optional data attributes for Stimulus etc.
  def initialize(text:, path:, variant: :default, classes: nil, data: {})
    @text = text
    @path = path
    @variant = variant
    @classes = classes
    @data = data
  end

  private

  # Base classes for all links
  def base_classes
    "inline-flex items-center text-sm underline font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-background-primary"
  end

  # Variant-specific classes
  def variant_classes
    case @variant
    when :default
      "text-text-primary hover:text-primary" # Dark text, primary hover
    when :accent
      "text-primary hover:text-primary/80" # Primary text, slightly darker/lighter primary on hover
    # Add other variants like :subtle, :inverted if needed
    else
      "text-text-primary hover:text-primary" # Default to regular text color
    end
  end

  # Combines all classes, including any custom ones.
  def link_classes
    "#{base_classes} #{variant_classes} #{@classes}".strip
  end
end
