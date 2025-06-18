class AddCapabilitiesToLlmModel < ActiveRecord::Migration[8.0]
  def change
    add_column :llm_models, :can_search, :boolean, default: false
    add_column :llm_models, :can_reason, :boolean, default: false
  end
end
