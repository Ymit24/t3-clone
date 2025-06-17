# == Schema Information
#
# Table name: citations
#
#  id         :integer          not null, primary key
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  message_id :integer          not null
#
# Indexes
#
#  index_citations_on_message_id  (message_id)
#
# Foreign Keys
#
#  message_id  (message_id => messages.id)
#
class Citation < ApplicationRecord
  belongs_to :message
end
