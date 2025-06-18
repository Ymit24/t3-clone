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

require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
