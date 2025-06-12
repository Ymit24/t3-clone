class ChatThread < ApplicationRecord
  belongs_to :user
  has_many :chat_messages, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
end
