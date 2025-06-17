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
      api_key = chat.user.account.openai_key or raise InvalidApiKeyError, "No OpenAI API key found. Please add your API key in your account settings."
    when "openrouter"
      api_key = chat.user.account.openrouter_key or raise InvalidApiKeyError, "No OpenRouter API key found. Please add your API key in your account settings."
    else
      raise "Invalid provider: #{generation.llm_model.provider}"
    end

    puts "\n\n\n"
    puts "Starting OpenRouter chat completion for chat #{chat.id} with model #{generation.llm_model.model}"
    service = OpenrouterService.new
    response = service.chat_completion(
      provider: generation.llm_model.provider,
      api_key: api_key,
      model: generation.llm_model.model,
      messages: chat.messages,
      search_enabled: generation.search_enabled,
      reasoning_effort: generation.reasoning_effort,
    )
    assistant_message = response[:body]
    citations = response[:citations]
    puts "Successfully received response from OpenRouter"
    puts "\n\n\n"

    # Check if generation was canceled while we were waiting for the response
    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    if generation.reload.canceled?
      generation.destroy
      return
    end

    Chat.transaction do
      message = chat.messages.create!(
        value: assistant_message,
        llm_model: generation.llm_model,
        is_system: true,
      )

      citations.each do |citation|
        obj = citation[:url_citation]
        puts "Citation: #{obj.inspect}"
        message.citations.create!(
          title: obj[:title],
          url: obj[:url],
        )
      end

      chat.update!(generating: false)
      generation.destroy!
    end
  rescue InvalidApiKeyError => e
    handle_error(generation, "Please add your OpenRouter API key in your account settings.")
  rescue RateLimitError => e
    handle_error(generation, "Rate limit exceeded. Please try again in a few minutes.")
  rescue NetworkError => e
    handle_error(generation, "Network error occurred. Please check your internet connection and try again.")
  rescue InvalidModelError => e
    handle_error(generation, "The selected model is currently unavailable. Please try a different model.")
  rescue OpenRouterError => e
    handle_error(generation, "An error occurred with the OpenRouter service. Please try again later.")
  rescue => e
    puts "Unexpected error occurred: #{e.message}"
    handle_error(generation, "An unexpected error occurred. Please try again later.")
  end

  private

  def handle_error(generation, message)
    puts "Error occurred: #{message}"

    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    if generation.reload.canceled?
      generation.destroy!
      return
    end

    Chat.transaction do
      chat = generation.chat
      chat.messages.create!(
        value: message,
        is_system: true,
        llm_model: generation.llm_model,
      )
      chat.update!(generating: false)
      generation.destroy!
    end
  end
end
