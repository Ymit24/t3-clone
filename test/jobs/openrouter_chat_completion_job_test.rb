require "test_helper"

class OpenrouterChatCompletionJobTest < ActiveSupport::TestCase
  def test_creates_system_message_and_marks_generation_complete
    generation = generations(:one)
    chat = generation.chat
    account = chat.user.account
    account.update!(openrouter_key: "test-openrouter-key")

    service = Object.new
    def service.chat_completion(api_key:, model:, messages:, search_enabled:, reasoning_effort:)
      yield(
        choices: [
          {
            delta: {
              content: "Hello from AI"
            }
          }
        ]
      )
    end

    OpenrouterService.singleton_class.define_method(:new) { service }
    begin
      assert_difference("Message.count", 1) do
        OpenrouterChatCompletionJob.new.perform(generation)
      end
    ensure
      OpenrouterService.singleton_class.send(:remove_method, :new)
    end

    created_message = generation.chat.reload.messages.order(:created_at).last
    assert_equal generation.chat, created_message.chat
    assert_equal true, created_message.is_system
    assert_equal "Hello from AI", created_message.body
    assert_equal generation, created_message.generation
    assert_equal true, generation.reload.completed
    assert_equal false, generation.chat.reload.generating
  end
end
