class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.text :file_data
      t.references :folder

      t.timestamps
    end
  end
end
