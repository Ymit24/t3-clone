# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  generating :boolean          default(FALSE)
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_chats_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require "test_helper"

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
