class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :openrouter_key
      t.string :nickname, limit: 9

      t.timestamps
    end
  end
end
