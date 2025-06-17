class CreateCitations < ActiveRecord::Migration[8.0]
  def change
    create_table :citations do |t|
      t.string :title
      t.string :url
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end

    remove_column :messages, :citations
  end
end
