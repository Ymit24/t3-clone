class MessagesController < ApplicationController
    before_action :set_messages, only: %i[index create]

    def index
        @message = Message.new
    end

    def create
        @message = Current.user.messages.new(message_params)
        if @message.save
            redirect_to messages_path
        else
            render :index, status: :unprocessable_entity
        end
    end

    private

    def message_params
        params.require(:message).permit(:value, :llm_model_id)
    end

    def set_messages
        @messages = Current.user.messages
    end
end
