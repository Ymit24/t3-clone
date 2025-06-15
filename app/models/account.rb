# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  openrouter_key :string
#  nickname       :string(9)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#

class Account < ApplicationRecord
  belongs_to :user

  validates :nickname, length: { maximum: 9 }
end
