class ChatsController < ApplicationController
  def index
    @chats = Current.user.chats.ordered
  end

  def new
    chat = nil
    Chat.transaction do
      chat = Current.user.chats.create!(title: "Untitled Chat #{Current.user.chats.count+1}")
      chat.prompt = Prompt.create!(chat: chat, llm_model: LlmModel.first)
    end
    redirect_to chat_path(chat)
  end

  def show
    @chat = Current.user.chats.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end

  def destroy
    @chat = Current.user.chats.find(params[:id])
    @chat.destroy
    redirect_to root_url 
  end
end
