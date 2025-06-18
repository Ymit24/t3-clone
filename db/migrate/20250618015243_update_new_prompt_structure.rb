class UpdateNewPromptStructure < ActiveRecord::Migration[8.0]
  def change
    remove_reference :messages, :llm_model

    remove_column :messages, :search_enabled
    remove_column :messages, :reasoning_enabled

    rename_column :messages, :value, :body

    add_column :generations, :completed, :boolean, default: false
    add_reference :messages, :generation, foreign_key: true
  end
end
