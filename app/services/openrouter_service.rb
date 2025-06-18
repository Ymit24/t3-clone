class OpenrouterService

  def chat_completion(api_key:, model:, messages:, search_enabled:, reasoning_effort:, **_other)
    uri = URI("https://openrouter.ai/api/v1/chat/completions")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    req = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    })

    puts "[openrouter-service] search_enabled: #{search_enabled}"
    puts "[openrouter-service] reasoning_effort: #{reasoning_effort}"

    req.body = {
      model: model + (reasoning_effort != "none" ? ":thinking" : ""),
      plugins: search_enabled ? [{id: "web"}] : [],
      reasoning: {
        enabled: reasoning_effort != "none",
      },
      stream: true,
      messages: messages.map do |message|
        { role: message.is_system ? "assistant" : "user", content: message.body }
      end,
    }.to_json

    begin
      puts "[openrouter-service] \n\n\n\n----------------------"
      puts "[openrouter-service] about to start request"
      buffer = ""
      res = http.request(req) do |response|
        puts "[openrouter-service] got response"
        response.read_body do |chunk|
          puts "[openrouter-service] Chunk: '#{chunk}'"
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
              puts "[openrouter-service] Line: '#{line}'"
              if line.include?("data:")
                unless line.include?("[DONE]")
                  data = JSON.parse(line.split("data:")[1].strip, symbolize_names: true)
                  puts "[openrouter-service] Data: '#{data.inspect}'"
                  return if (yield data) == :cancel
                end
              else
                puts "[openrouter-service] [DONE]"
              end
            end
          end
        end
      end
      puts "[openrouter-service] +++++++++++++++++++++++++++\n\n\n"
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
