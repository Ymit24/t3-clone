# == Schema Information
#
# Table name: llm_models
#
#  id         :integer          not null, primary key
#  can_reason :boolean          default(FALSE)
#  can_search :boolean          default(FALSE)
#  model      :string           not null
#  name       :string           not null
#  provider   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class LlmModelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
