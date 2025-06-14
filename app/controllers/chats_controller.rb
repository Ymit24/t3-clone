class ChatsController < ApplicationController
  def index
    @chats = Current.user.chats.ordered
  end

  def show
    @chat = Current.user.chats.find(params[:id])
    @message = @chat.messages.new
  end
end
