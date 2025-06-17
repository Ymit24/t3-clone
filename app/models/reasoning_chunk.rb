# == Schema Information
#
# Table name: reasoning_chunks
#
#  id         :integer          not null, primary key
#  body       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  message_id :integer          not null
#
# Indexes
#
#  index_reasoning_chunks_on_message_id  (message_id)
#
# Foreign Keys
#
#  message_id  (message_id => messages.id)
#
class ReasoningChunk < ApplicationRecord
  belongs_to :message

  validates :message, presence: true
end
