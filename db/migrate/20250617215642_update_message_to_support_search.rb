class UpdateMessageToSupportSearch < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :citations, :string, default: ""
  end
end
