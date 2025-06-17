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
require "test_helper"

class CitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
