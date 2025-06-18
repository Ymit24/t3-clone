class Messages::RetryController < ApplicationController
  def create
    message = Current.user.chats.find(params[:chat_id]).messages.find(params[:message_id])
    if message.chat.generating
      head :ok
      return
    end
    messages = message.chat.messages.after_message(message)

    generation = message.generation
      puts "generation: #{generation.inspect}"
    Message.transaction do
      message.chat.update!(generating: true)
      generation.update!(completed: false, content: "")
      if message.is_system
        message.destroy!
      end
      messages.destroy_all
    end
    puts "\n\n\n\n\n\n\n\n\nabout to generate retry"
    puts "generation: #{generation.inspect}"
    puts "\n\n\n\n\n\n\n\n\n"
    OpenrouterChatCompletionJob.perform_later(generation)

    head :ok
  end
end
