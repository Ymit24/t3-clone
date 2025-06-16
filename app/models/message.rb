# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :integer          not null
#  llm_model_id :integer
#
# Indexes
#
#  index_messages_on_chat_id  (chat_id)
#  index_messages_on_llm_model_id  (llm_model_id)
#
class Message < ApplicationRecord
  belongs_to :llm_model, optional: true
  belongs_to :chat

  validates :value, presence: true
  validates :chat, presence: true

  scope :ordered, -> { order(created_at: :asc) }

  broadcasts_to ->(message) { [message.chat, :messages] }

  after_create_commit do
    if is_system
      broadcast_update_to [chat, :loading_status], target: "loading-status", html: ""
    else
      broadcast_replace_to [chat, :loading_status], target: "loading-status", partial: "messages/loading_indicator"
    end
  end
end
