class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :user
      t.references :trackable
      t.integer :project_id
      t.integer :folder_id
      t.string :action
      t.string :trackable_type

      t.timestamps
    end
  end
end
