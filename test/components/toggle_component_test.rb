# frozen_string_literal: true

require "test_helper"

class ToggleComponentTest < ViewComponent::TestCase
  def test_renders_search_toggle
    prompt = prompts(:one)
    form = Struct.new(:object_name) do
      def check_box(attribute, **options)
        checked = options[:checked] ? ' checked="checked"' : ""
        data = options[:data].map { |key, value| %( data-#{key.to_s.tr("_", "-")}="#{value}") }.join
        %(<input type="checkbox" name="#{object_name}[#{attribute}]"#{checked}#{data}>)
      end
    end.new("prompt")
    rendered = render_inline(
      ToggleComponent.new(
        form: form,
        attribute: :search_enabled,
        icon: "globe-alt",
        label: "Search",
        initial_checked: true,
      )
    )

    assert_includes rendered.text, "Search"
    assert_includes rendered.to_html, 'data-controller="toggle-button"'
    assert_includes rendered.to_html, 'data-checked="true"'
    assert_includes rendered.to_html, 'type="checkbox"'
  end
end
