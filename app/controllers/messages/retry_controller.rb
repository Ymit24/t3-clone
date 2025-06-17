class Messages::RetryController < ApplicationController
  def create
    message = Current.user.chats.find(params[:chat_id]).messages.find(params[:message_id])
    messages = message.chat.messages.after_message(message)

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
      OpenrouterChatCompletionJob.perform_later(generation)
    end

    head :ok
  end
end
