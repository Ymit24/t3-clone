# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chats_on_user_id  (user_id)
#

class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }

  validates :user, presence: true
  validates :title, presence: true

  broadcasts_to ->(chat) { [chat.user, :chats] }
end
