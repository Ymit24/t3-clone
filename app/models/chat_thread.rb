class ChatThread < ApplicationRecord
  belongs_to :user
  has_many :chat_messages, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }

  broadcasts_to ->(thread) { [thread.user, :chat_threads] }, partial: "chat_threads/thread_list", target: "chat_threads"
end
