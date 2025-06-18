class OpenrouterService

  def chat_completion(provider:, api_key:, model:, messages:, search_enabled:, reasoning_effort:)
    case provider
    when "openai"
      uri = URI("https://api.openai.com/v1/chat/completions")
    when "openrouter"
      uri = URI("https://openrouter.ai/api/v1/chat/completions")
    else
      raise "Invalid provider: #{provider}"
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    req = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    })

    puts "[service] search_enabled: #{search_enabled}"
    puts "[service] reasoning_effort: #{reasoning_effort}"

    req.body = {
      model: model + (reasoning_effort != "none" ? ":thinking" : ""),
      plugins: search_enabled ? [{id: "web"}] : [],
      reasoning: {
        enabled: reasoning_effort != "none",
      },
      stream: true,
      messages: messages.map do |message|
        { role: message.is_system ? "assistant" : "user", content: message.value }
      end,
    }.to_json

    begin
      puts "[service] \n\n\n\n----------------------"
      puts "[service] about to start request"
      buffer = ""
      res = http.request(req) do |response|
        puts "[service] got response"
        response.read_body do |chunk|
          puts "[service] Chunk: '#{chunk}'"
          buffer += chunk

          begin
            current = JSON.parse(buffer, symbolize_names: true)
            if current.key?(:error)
              raise OpenrouterChatCompletionJob::OpenRouterError, "Error: #{current[:error][:message]}"
            end
          rescue JSON::ParserError
            # nothing
          end

          while (event, rest = buffer.split("\n\n", 2)).size == 2
            buffer = rest

            event.lines.each do |line|
              puts "[service] Line: '#{line}'"
              if line.include?("data:")
                unless line.include?("[DONE]")
                  data = JSON.parse(line.split("data:")[1].strip, symbolize_names: true)
                  puts "[service] Data: '#{data.inspect}'"
                  yield data
                end
              else
                puts "[service] [DONE]"
              end
            end
          end
        end
      end
      puts "[service] +++++++++++++++++++++++++++\n\n\n"
      return {body: "",citations: []}

      raise "this should never happen"

      response_body = JSON.parse(res.body, symbolize_names: true)

      puts "[service] \n\n\n\n----------------------"
      puts "[service] RESPONSE:", JSON.pretty_generate(response_body)
      puts "[service] +++++++++++++++++++++++++++\n\n\n"

      case res.code
      when "200"
        body = response_body.dig(:choices, 0, :message, :content)
        citations = response_body.dig(:choices, 0, :message).fetch(:annotations, [])
        {
          body: body,
          citations: citations,
        }
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
      puts "JSON::ParserError: #{res.body}"
      raise OpenrouterChatCompletionJob::OpenRouterError, "Invalid response from server"
    rescue Net::OpenTimeout, Net::ReadTimeout 
      puts "Net::OpenTimeout, Net::ReadTimeout: #{res.body}"
      puts "Request: #{req.body}"
      raise OpenrouterChatCompletionJob::NetworkError, "Request timed out"
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET
      puts "Errno::ECONNREFUSED, Errno::ECONNRESET: #{res.body}"
      raise OpenrouterChatCompletionJob::NetworkError, "Connection failed"
    rescue SocketError
      puts "SocketError: #{res.body}"
      raise OpenrouterChatCompletionJob::NetworkError, "Network connection error"
    end
  end
end 
