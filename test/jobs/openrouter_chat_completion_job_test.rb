require 'test_helper'
require 'net/http'
require 'minitest/mock'

class OpenrouterChatCompletionJobTest < ActiveSupport::TestCase
  module NetHTTPMock
    def request(req)
      response = Minitest::Mock.new
      response.expect :body, {
        id: 'chatcmpl-123',
        object: 'chat.completion',
        choices: [
          { message: { role: 'assistant', content: 'I am an AI.' } }
        ]
      }.to_json
      response.expect :code, '200'
      response
    end
  end

  def test_creates_assistant_message_for_user
    user = User.first || User.create!(email_address: 'test@example.com', password: 'password')
    llm_model = LlmModel.first || LlmModel.create!(name: 'OpenAI', provider: 'openai', model: 'gpt-4o')
    user.messages.destroy_all
    user.messages.create!(value: 'Hello, who are you?', llm_model: llm_model)

    Net::HTTP.prepend(NetHTTPMock)
    assert_difference -> { user.messages.count }, +1 do
      OpenrouterChatCompletionJob.new.perform(user, llm_model)
    end
    assert user.messages.where(is_system: true, value: 'I am an AI.').exists?
  ensure
    Net::HTTP.singleton_class.send(:remove_method, :request) if Net::HTTP.singleton_class.method_defined?(:request)
  end
end