require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  test  'folder name must be present' do
    folder = Folder.new
    folder.valid?
    assert_includes(folder.errors[:name], "doit être rempli(e)")
  end

  test 'folder name should be unique in the scope of its parent folder (i.e. siblings have unique names)' do
    parent_folder = folders(:folder_one)
    sibling_folder = parent_folder.siblings.build(name: parent_folder.name)
    sibling_folder.valid?
    assert_includes(sibling_folder.errors[:name], "indisponible. Merci d'en choisir un autre.")
  end

  test 'folder must be associated to a project' do
    folder = Folder.new
    folder.valid?
    assert_includes(folder.errors[:project], "doit exister")
  end

  test '#has_resources_not_owned_by_user? returns true if folder contains subfolders owned by another user' do
    project = projects(:pyramid)
    user_1 = users(:one)
    user_2 = users(:two)

    parent_folder = Folder.create(name: "Parent folder", user: user_1, project: project)
    parent_folder.children.create(name: "Child folder",  user: user_2, project: project)

    assert_not parent_folder.contains_only_resources_owned_by_user?(user_1)
  end

  test '#has_resources_not_owned_by_user? returns true if folder contains documents owned by another user' do
    project = projects(:pyramid)
    user_1 = users(:one)
    user_2 = users(:two)

    document = documents(:document_one)

    parent_folder = Folder.create(
      name: "Parent folder",
      user: user_1,
      project: project,
      documents: [document])

    user_2.documents << document

    assert_not parent_folder.contains_only_resources_owned_by_user?(user_1)
  end
end
