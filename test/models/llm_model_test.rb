# == Schema Information
#
# Table name: llm_models
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  provider   :string           not null
#  model      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class LlmModelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
