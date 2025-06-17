class AddRoleToAccount < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :role, :string, default: "Guest", null: false
  end
end
