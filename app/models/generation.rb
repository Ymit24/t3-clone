# == Schema Information
#
# Table name: generations
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  llm_model_id :integer       not null
#  content    :text
#  canceled   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_generations_on_chat_id     (chat_id)
#  index_generations_on_llm_model_id (llm_model_id)
#

class Generation < ApplicationRecord
  belongs_to :chat
  belongs_to :llm_model

  validates :chat, presence: true
  validates :llm_model, presence: true
end 