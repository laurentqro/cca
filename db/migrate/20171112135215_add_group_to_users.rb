class AddGroupToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :group, :integer, default: 0
  end
end
