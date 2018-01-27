class RemoveCompanyFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :company, :string
  end
end
