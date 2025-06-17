class MessagesController < ApplicationController
    before_action :set_chat, only: %i[edit show create update]
    before_action :set_message, only: %i[edit show update]

    def show; end

    def edit; end

    def update
      if @message.update(message_params)
        render :show
      else
        render :edit
      end
    end

    def create
      @message = @chat.messages.new(message_params)
      puts "\n\n\n\n--------------------------------"
      puts "message_params: #{message_params}"
      puts "search_enabled: #{@message.search_enabled}"
      puts "reasoning_enabled: #{@message.reasoning_enabled}"
      puts "--------------------------------\n\n\n\n"
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

    def set_message
      @message = @chat.messages.find(params[:id])
    end

    def message_params
        params.require(:message).permit(:value, :llm_model_id, :search_enabled, :reasoning_enabled)
    end
end
