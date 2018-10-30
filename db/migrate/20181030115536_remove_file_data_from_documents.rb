class RemoveFileDataFromDocuments < ActiveRecord::Migration[5.2]
  def change
    remove_column :documents, :file_data, :string
  end
end
