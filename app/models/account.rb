# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  nickname       :string(9)
#  openai_key     :string
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

class Account < ApplicationRecord
  belongs_to :user

  validates :nickname, length: { maximum: 9 }

  def has_api_key?
    openrouter_key.present? || openai_key.present?
  end
end
