class AddCompanyToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :company, index: true
  end
end
