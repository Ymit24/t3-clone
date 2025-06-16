module Chats
  class CancelController < ApplicationController
    def create
      chat = Current.user.chats.find(params[:chat_id])

      generation = chat.generations.where(canceled: false).first

      raise "No generations to cancel!" unless generation
      
      Chat.transaction do
        generation.update!(canceled: true)
        chat.update!(generating: false)
      end

      head :ok
    end
  end
end 