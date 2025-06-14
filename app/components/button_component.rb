class ButtonComponent < ViewComponent::Base
  def initialize(text:, variant: :primary)
    @text = text
    @variant = variant
  end

  private

  def button_classes
    case @variant
    when :primary
      "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    when :secondary
      "bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded"
    else
      "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    end
  end
end 