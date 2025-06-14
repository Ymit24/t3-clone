class MessagesController < ApplicationController
    def index
        @messages = Current.user.messages
        @message = Message.new
    end

    def create
        @message = Current.user.messages.create(message_params)
        redirect_to messages_path
    end

    private

    def message_params
        params.require(:message).permit(:value, :llm_model_id)
    end
end
