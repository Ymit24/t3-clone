class Chats::PromptsController < ApplicationController
    before_action :set_prompt

    def edit
    end

    def update
        puts "update-----", prompt_params
        @prompt.update(prompt_params)
        respond_to do |format|
            format.turbo_stream
        end
    end

    private

    def prompt_params
        raw = params.require(:prompt).permit(:body, :llm_model_id, :search_enabled, :reasoning_enabled).to_h
        raw[:searching] = raw.delete(:search_enabled)
        raw[:reasoning] = raw.delete(:reasoning_enabled)
        raw
    end

    def set_prompt
        @prompt ||= Current.user.chats.find(params[:chat_id]).prompt
    end
end
