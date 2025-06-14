class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :value
      t.references :llm_model, null: false, foreign_key: true
      t.boolean :is_system, default: false

      t.timestamps
    end
  end
end
