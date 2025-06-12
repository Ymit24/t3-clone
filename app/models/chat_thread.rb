# == Schema Information
#
# Table name: chat_threads
#
#  id         :integer          not null, primary key
#  title      :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_threads_on_user_id  (user_id)
#

class ChatThread < ApplicationRecord
  belongs_to :user
  has_many :chat_messages, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }

  broadcasts_to ->(thread) { [ thread.user, :chat_threads ] }, partial: "chat_threads/thread_list", target: "chat_threads"
end
