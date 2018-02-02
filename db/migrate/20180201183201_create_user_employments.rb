class CreateUserEmployments < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
      t.belongs_to :company, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
