# == Schema Information
#
# Table name: messages
#
#  id                :integer          not null, primary key
#  is_system         :boolean          default(FALSE)
#  reasoning_enabled :boolean          default(FALSE), not null
#  search_enabled    :boolean          default(FALSE), not null
#  value             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chat_id           :integer          not null
#  llm_model_id      :integer          not null
#
# Indexes
#
#  index_messages_on_chat_id       (chat_id)
#  index_messages_on_llm_model_id  (llm_model_id)
#
# Foreign Keys
#
#  chat_id       (chat_id => chats.id)
#  llm_model_id  (llm_model_id => llm_models.id)
#
class Message < ApplicationRecord
  belongs_to :llm_model, optional: true
  belongs_to :chat
  has_many :citations, dependent: :destroy
  has_many :reasoning_chunks, dependent: :destroy

  validates :chat, presence: true

  scope :ordered, -> { order(created_at: :asc) }
  scope :after_message, ->(message) { where("created_at > ?", message.created_at).order(created_at: :asc) }

  broadcasts_to ->(message) { [ message.chat, :messages ] }
end
