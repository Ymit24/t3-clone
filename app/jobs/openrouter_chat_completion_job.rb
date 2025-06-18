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
    puts "Starting OpenRouter chat completion for chat #{chat.id} with model #{generation.llm_model.model}"

    message = chat.messages.create!(
      value: "",
      llm_model: generation.llm_model,
      is_system: true,
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
      # message.update!(value: "thinking... chunk: #{chunk.inspect}")
      if chunk.key?(:error)
        puts "found error"
        message.update!(value: message.value + "Error: #{chunk[:error][:message]}")
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
        message.update!(value: message.value + content)
      end
    end

    puts "done receiving chunks"

    puts "Successfully received response from OpenRouter"
    puts "\n\n\n"

    # Check if generation was canceled while we were waiting for the response
    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    if generation.reload.canceled?
      Chat.transaction do
        generation.destroy!
        chat.update!(generating: false)
      end
      return
    end

    Chat.transaction do
      # citations.each do |citation|
      #   obj = citation[:url_citation]
      #   puts "Citation: #{obj.inspect}"
      #   message.citations.create!(
      #     title: obj[:title],
      #     url: obj[:url],
      #   )
      # end

      chat.update!(generating: false)
      generation.destroy!
    end
  rescue => e
    puts "Unexpected error occurred: #{e.message}"
    handle_error(generation, "An unexpected error occurred. Please try again later.")
  end

  private

  def handle_error(generation, message)
    puts "Error occurred: #{message}"

    puts "\n\n\n\n----------------\nis canceled: #{generation.reload.inspect}\n+++++++++++++\n\n\n\n\n"
    Chat.transaction do
      chat = generation.chat
      chat.messages.last.update!(value: chat.messages.last.value + message)
      chat.update!(generating: false)
      generation.destroy!
    end
  end
end
