class ChatsController < ApplicationController
  def index
    @chats = Current.user.chats.ordered
  end

  def new
    chat = Current.user.chats.create!(title: "Untitled Chat")
    redirect_to chat_path(chat)
  end

  def show
    @chat = Current.user.chats.find(params[:id])
    @message = @chat.messages.new
  end
end
