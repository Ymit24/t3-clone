class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show destroy]
  def index
    @chats = Current.user.chats.ordered
  end

  def new
    chat = Current.user.chats.create!(title: "Untitled Chat #{Current.user.chats.count+1}")
    redirect_to chat_path(chat)
  end

  def show
    redirect_to root_url unless @chat
  end

  def destroy
    @chat.destroy
   redirect_to root_url 
  end

  private

  def set_chat
    @chat = Current.user.chats.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @chat = nil
  end
end
