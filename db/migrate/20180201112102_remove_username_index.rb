class RemoveUsernameIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index(:users, column: :username)
  end
end
