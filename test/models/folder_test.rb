require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  test "folder name should be unique in the scope of its parent folder (i.e. siblings have unique names)" do
    parent_folder = folders(:folder_one)
    sibling_folder = parent_folder.siblings.build(name: parent_folder.name)

    sibling_folder.valid?

    assert_includes(sibling_folder.errors[:name], "indisponible. Merci d'en choisir un autre.")
  end
end
