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

    puts "\n\n\n"
    puts "Starting #{generation.llm_model.provider} chat completion for chat #{chat.id} with model #{generation.llm_model.model}"

    message = chat.messages.create!(
      body: "",
      is_system: true,
      generation: generation,
    )

    puts "about to start chat completion"
    service.chat_completion(
      api_key: api_key,
      model: generation.llm_model.model,
      messages: chat.messages,
      search_enabled: generation.search_enabled,
      reasoning_effort: generation.reasoning_effort,
    ) do |chunk|
      puts "Chunk: #{chunk}"
      if chunk.key?(:error)
        puts "found error"
        message.update!(body: message.body + "Error: #{chunk[:error][:message]}")
        return
      end

      chunk = chunk[:choices].first
      puts "Choice: #{chunk.inspect}"

      annotations = chunk[:delta][:annotations]
      annotations&.each do |annotation|
        url = annotation[:url_citation]
        puts "URL: #{url.inspect}"
        if url
          title = url[:title]
          url = url[:url]
          unless message.citations.where(title: title, url: url).exists?
            puts "\n\t\t\t[JOB] Creating citation: #{title} #{url}\n"
            citation =message.citations.create!(title: title, url: url)
            puts "\n\t\t\t[JOB] Citation created: #{citation.inspect}\n"
          end
        end
      end

      reasoning = chunk[:delta][:reasoning]
      if reasoning
        message.reasoning_chunks.create!(body: reasoning)
      end

      content = chunk[:delta][:content]
      if content
        message.update!(body: message.body + content)
      end
    end

    puts "done receiving chunks"

    puts "Successfully received response from OpenRouter"
    puts "\n\n\n"

    # Check if generation was canceled while we were waiting for the response
    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    puts "messages: #{generation.messages.inspect}"
    generation.update!(completed: true)
    chat.update!(generating: false)
  rescue => e
    puts "Unexpected error occurred: #{e.message}"
    handle_error(generation, "An unexpected error occurred. Please try again later.")
  end

  private

  def handle_error(generation, message)
    puts "Error occurred: #{message}"

    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    puts "messages: #{generation.messages.inspect}"
    Chat.transaction do
      chat = generation.chat
      chat.messages.last.update!(body: chat.messages.last.body + message)
      chat.update!(generating: false)
      generation.update!(completed: true)
    end
  end
end
