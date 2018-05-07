class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :subscribeable, polymorphic: true, index: true
      t.references :user
      t.timestamps
    end
  end
end
