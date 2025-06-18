# == Schema Information
#
# Table name: prompts
#
#  id           :integer          not null, primary key
#  body         :string
#  reasoning    :boolean
#  searching    :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_id      :integer          not null
#  llm_model_id :integer          not null
#
# Indexes
#
#  index_prompts_on_chat_id       (chat_id)
#  index_prompts_on_llm_model_id  (llm_model_id)
#
# Foreign Keys
#
#  chat_id       (chat_id => chats.id)
#  llm_model_id  (llm_model_id => llm_models.id)
#
class Prompt < ApplicationRecord
  belongs_to :chat
  belongs_to :llm_model
end
