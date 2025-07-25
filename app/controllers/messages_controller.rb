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
      if @message.save
        @chat.update!(generating: true)
        generation = @chat.generations.create!(
          llm_model: @chat.prompt.llm_model,
          content: "",
          search_enabled: @chat.prompt.searching && @chat.prompt.llm_model.can_search,
          reasoning_effort: @chat.prompt.reasoning && @chat.prompt.llm_model.can_reason ? "medium" : "none"
        )
        puts "CREATED GENERATION: #{generation.inspect}"
        @message.update!(generation: generation)
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
        params.require(:message).permit(:body)
    end
end
