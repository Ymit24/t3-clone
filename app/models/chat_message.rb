class ChatMessage < ApplicationRecord
  belongs_to :chat_thread
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
end
