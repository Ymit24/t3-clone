class CreateReasoningChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :reasoning_chunks do |t|
      t.string :body
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
