class RemoveCompanyId < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :company_id, :integer
  end
end
