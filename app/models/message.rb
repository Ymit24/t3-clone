# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :string
#  is_system     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_id       :integer          not null
#  generation_id :integer
#
# Indexes
#
#  index_messages_on_chat_id        (chat_id)
#  index_messages_on_generation_id  (generation_id)
#
# Foreign Keys
#
#  chat_id        (chat_id => chats.id)
#  generation_id  (generation_id => generations.id)
#
class Message < ApplicationRecord
  belongs_to :chat
  has_many :citations, dependent: :destroy
  has_many :reasoning_chunks, dependent: :destroy
  belongs_to :generation, optional: true

  validates :chat, presence: true

  scope :ordered, -> { order(created_at: :asc) }
  scope :after_message, ->(message) { where("created_at > ?", message.created_at).order(created_at: :asc) }

  broadcasts_to ->(message) { [ message.chat, :messages ] }
end
