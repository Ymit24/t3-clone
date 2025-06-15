class HomeController < ApplicationController
  def index
    chat = Current.user.chats.first || Current.user.chats.create!(title: "Untitled Chat 1")
    redirect_to chat_path(chat)
  end
end
