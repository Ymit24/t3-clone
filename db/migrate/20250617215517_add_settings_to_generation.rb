class AddSettingsToGeneration < ActiveRecord::Migration[8.0]
  def change
    add_column :generations, :search_enabled, :boolean, default: false
    add_column :generations, :reasoning_effort, :string, default: "none"
  end
end
