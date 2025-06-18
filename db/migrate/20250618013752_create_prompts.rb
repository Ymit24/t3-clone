class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :body
      t.references :llm_model, null: false, foreign_key: true
      t.boolean :searching
      t.boolean :reasoning

      t.timestamps
    end
    Chat.all.each do |chat|
      unless chat.prompt.present? 
        chat.prompt = Prompt.create!(chat: chat, llm_model: LlmModel.first)
      end
    end
  end
end
