# frozen_string_literal: true

class ToggleComponent < ViewComponent::Base
    def initialize(form:, attribute:, icon:, label:, initial_checked: false)
        @form = form
        @attribute = attribute
        @icon = icon
        @label = label
        @initial_checked = initial_checked
    end
end
