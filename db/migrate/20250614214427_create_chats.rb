class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end

    remove_reference :messages, :user
    add_reference :messages, :chat, null: false, foreign_key: true
  end
end
