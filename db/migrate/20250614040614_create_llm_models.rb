class CreateLlmModels < ActiveRecord::Migration[8.0]
  def change
    create_table :llm_models do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.string :model, null: false

      t.timestamps
    end
  end
end
