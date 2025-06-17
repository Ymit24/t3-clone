class Messages::RetryController < ApplicationController
  def create
    message = Current.user.chats.find(params[:chat_id]).messages.find(params[:message_id])
    if message.chat.generating
      head :ok
      return
    end
    messages = message.chat.messages.after_message(message)

    generation = nil
    Message.transaction do
      message.chat.update!(generating: true)
      generation = message.chat.generations.create!(
        llm_model: message.llm_model,
        content: ""
      )
      if message.is_system
        message.destroy!
      end
      messages.destroy_all
    end
    OpenrouterChatCompletionJob.perform_later(generation)

    head :ok
  end
end
