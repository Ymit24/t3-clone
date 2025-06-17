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
  has_many :generations, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }

  validates :user, presence: true
  validates :title, presence: true

  broadcasts_to ->(chat) { [ chat.user, :chats ] }

  after_save_commit do
    broadcast_update_to(
      [ self, :send_button ],
      target: "send-button",
      partial: "messages/send_button",
      locals: { chat: self }
    )

    if generating
      broadcast_replace_to [ self, :loading_status ], target: "loading-status", partial: "messages/loading_indicator"
    else
      broadcast_update_to [ self, :loading_status ], target: "loading-status", html: ""
    end
  end
end
