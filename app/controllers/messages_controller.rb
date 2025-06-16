class MessagesController < ApplicationController
    before_action :set_chat

    def create
        @message = @chat.messages.new(message_params)
        if @message.save
          @chat.update!(generating: true)
          generation = @chat.generations.create!(
            llm_model: @message.llm_model,
            content: ""
          )
          OpenrouterChatCompletionJob.perform_later(generation)
          @message = @chat.messages.new
        end
        respond_to do |format|
          format.turbo_stream
        end
    end

    private

    def set_chat
        @chat = Current.user.chats.find(params[:chat_id])
    end

    def message_params
        params.require(:message).permit(:value, :llm_model_id)
    end
end
