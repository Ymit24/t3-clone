class CreateGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :generations do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :llm_model, null: false, foreign_key: true
      t.text :content
      t.boolean :canceled, default: false

      t.timestamps
    end
  end
end 