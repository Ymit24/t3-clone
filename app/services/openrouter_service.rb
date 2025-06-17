class OpenrouterService
  def initialize(api_key)
    @api_key = api_key
  end

  def chat_completion(model:, messages:)
    uri = URI("https://openrouter.ai/api/v1/chat/completions")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    req = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@api_key}"
    })

    req.body = {
      model: model,
      messages: messages.map do |message|
        { role: message.is_system ? "assistant" : "user", content: message.value }
      end
    }.to_json

    begin
      res = http.request(req)
      response_body = JSON.parse(res.body, symbolize_names: true)

      puts "\n\n\n\n----------------------"
      puts "RESPONSE:", JSON.pretty_generate(response_body)
      puts "++++++++++++++++++++++++++\n\n\n"

      case res.code
      when "200"
        response_body.dig(:choices, 0, :message, :content)
      when "401"
        if response_body[:error]&.include?("Invalid API key")
          raise OpenrouterChatCompletionJob::InvalidApiKeyError, "Invalid API key"
        else
          raise OpenrouterChatCompletionJob::OpenRouterError, "Authentication error"
        end
      when "429"
        if response_body[:error]&.include?("rate limit")
          raise OpenrouterChatCompletionJob::RateLimitError, "Rate limit exceeded"
        else
          raise OpenrouterChatCompletionJob::OpenRouterError, "Too many requests"
        end
      when "400"
        error_message = response_body[:error]&.downcase || ""
        if error_message.include?("model") || error_message.include?("not found")
          raise OpenrouterChatCompletionJob::InvalidModelError, "Model not available"
        elsif error_message.include?("token") || error_message.include?("length")
          raise OpenrouterChatCompletionJob::OpenRouterError, "Message too long"
        else
          raise OpenrouterChatCompletionJob::OpenRouterError, "Invalid request"
        end
      when "503"
        raise OpenrouterChatCompletionJob::OpenRouterError, "Service temporarily unavailable"
      when "500"
        raise OpenrouterChatCompletionJob::OpenRouterError, "Internal server error"
      else
        raise OpenrouterChatCompletionJob::OpenRouterError, "Unexpected error occurred"
      end
    rescue JSON::ParserError
      raise OpenrouterChatCompletionJob::OpenRouterError, "Invalid response from server"
    rescue Net::OpenTimeout, Net::ReadTimeout
      raise OpenrouterChatCompletionJob::NetworkError, "Request timed out"
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET
      raise OpenrouterChatCompletionJob::NetworkError, "Connection failed"
    rescue SocketError
      raise OpenrouterChatCompletionJob::NetworkError, "Network connection error"
    end
  end
end 
