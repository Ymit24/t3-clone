require "net/http"


class OpenrouterChatCompletionJob < ApplicationJob
  queue_as :default

  def perform(chat, llm_model)
    api_key = ENV["OPENROUTER_API_KEY"] or raise "OPENROUTER_API_KEY is not set"

    uri = URI("https://openrouter.ai/api/v1/chat/completions")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    })
    req.body = {
      model: llm_model.model,
      messages: chat.messages.map do |message|
        { role: message.is_system ? "assistant" : "user", content: message.value }
      end
    }.to_json
    res = http.request(req)
    if res.code == "200"
      json = JSON.parse(res.body, symbolize_names: true)
      puts "json: #{json}"
      assistant_message = json.dig(:choices, 0, :message, :content)

      chat.messages.create(
        value: assistant_message,
        llm_model: llm_model,
        is_system: true,
      )
    else
      raise "OpenRouter API error: #{res.code}"
    end
  rescue => e
    puts "error occurred: #{e.message}"
  end
end

