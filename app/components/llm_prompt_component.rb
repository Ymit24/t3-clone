# frozen_string_literal: true

class LlmPromptComponent < ViewComponent::Base
  def initialize(form:, errors:)
    @form = form
    @errors = errors
  end
end
