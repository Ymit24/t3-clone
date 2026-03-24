require "net/http"
require_relative "../services/openrouter_service"


class OpenrouterChatCompletionJob < ApplicationJob
  queue_as :default

  class OpenRouterError < StandardError; end
  class InvalidApiKeyError < OpenRouterError; end
  class RateLimitError < OpenRouterError; end
  class NetworkError < OpenRouterError; end
  class InvalidModelError < OpenRouterError; end

  def perform(generation)
    chat = generation.chat

    case generation.llm_model.provider
    when "openai"
      service = OpenaiService.new
      api_key = chat.user.account.openai_key or raise InvalidApiKeyError, "No OpenAI API key found. Please add your API key in your account settings."
    when "openrouter"
      service = OpenrouterService.new
      api_key = chat.user.account.openrouter_key or raise InvalidApiKeyError, "No OpenRouter API key found. Please add your API key in your account settings."
    else
      raise "Invalid provider: #{generation.llm_model.provider}"
    end

    message = chat.messages.create!(
      body: "",
      is_system: true,
      generation: generation,
    )

    service.chat_completion(
      api_key: api_key,
      model: generation.llm_model.model,
      messages: chat.messages,
      search_enabled: generation.search_enabled,
      reasoning_effort: generation.reasoning_effort,
    ) do |chunk|
      if chunk.key?(:error)
        message.update!(body: message.body + "Error: #{chunk[:error][:message]}")
        return
      end

      if generation.reload.canceled?
        return :cancel
      end

      chunk = chunk[:choices].first

      annotations = chunk[:delta][:annotations]
      annotations&.each do |annotation|
        url = annotation[:url_citation]
        if url
          title = url[:title]
          url = url[:url]
          unless message.citations.where(title: title, url: url).exists?
            citation = message.citations.create!(title: title, url: url)
          end
        end
      end

      reasoning = chunk[:delta][:reasoning]
      if reasoning && reasoning.present?
        message.reasoning_chunks.create!(body: reasoning)
      end

      content = chunk[:delta][:content]
      if content && content.present?
        message.update!(body: message.body + content)
      end
    end

    # Check if generation was canceled while we were waiting for the response
    generation.update!(completed: true)
    chat.update!(generating: false)
  rescue => e
    handle_error(generation, "An unexpected error occurred. Please try again later.")
  end

  private

  def handle_error(generation, message)
    Chat.transaction do
      chat = generation.chat
      chat.messages.last.update!(body: chat.messages.last.body + message)
      chat.update!(generating: false)
      generation.update!(completed: true)
    end
  end
end
