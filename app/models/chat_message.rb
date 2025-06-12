# == Schema Information
#
# Table name: chat_messages
#
#  id             :integer          not null, primary key
#  content        :text
#  chat_thread_id :integer          not null
#  user_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_chat_messages_on_chat_thread_id  (chat_thread_id)
#  index_chat_messages_on_user_id         (user_id)
#

class ChatMessage < ApplicationRecord
  belongs_to :chat_thread
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
end
