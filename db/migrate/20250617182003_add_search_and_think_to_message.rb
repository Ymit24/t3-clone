class AddSearchAndThinkToMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :search_enabled, :boolean, default: false, null: false
    add_column :messages, :reasoning_enabled, :boolean, default: false, null: false
  end
end
