# == Schema Information
#
# Table name: generations
#
#  id               :integer          not null, primary key
#  canceled         :boolean          default(FALSE)
#  completed        :boolean          default(FALSE)
#  content          :text
#  reasoning_effort :string           default("none")
#  search_enabled   :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chat_id          :integer          not null
#  llm_model_id     :integer          not null
#
# Indexes
#
#  index_generations_on_chat_id       (chat_id)
#  index_generations_on_llm_model_id  (llm_model_id)
#
# Foreign Keys
#
#  chat_id       (chat_id => chats.id)
#  llm_model_id  (llm_model_id => llm_models.id)
#

class Generation < ApplicationRecord
  belongs_to :chat
  belongs_to :llm_model

  has_many :messages, dependent: :destroy

  validates :chat, presence: true
  validates :llm_model, presence: true
end 
