# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  is_system    :boolean          default(FALSE)
#  value        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_id      :integer          not null
#  llm_model_id :integer          not null
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

require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
