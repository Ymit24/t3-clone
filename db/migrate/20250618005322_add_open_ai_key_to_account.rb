class AddOpenAiKeyToAccount < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :openai_key, :string
  end
end
