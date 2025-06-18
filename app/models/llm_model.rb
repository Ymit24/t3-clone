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

class LlmModel < ApplicationRecord
  has_many :generations, dependent: :destroy
  has_many :prompts, dependent: :destroy

  validates :name, presence: true
  validates :provider, presence: true
  validates :model, presence: true
end
