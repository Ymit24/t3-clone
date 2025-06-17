# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  nickname       :string(9)
#  openrouter_key :string
#  role           :string           default("Guest"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
