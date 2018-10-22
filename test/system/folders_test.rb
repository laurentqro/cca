require "application_system_test_case"

class FoldersTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a folder' do
    folder = folders(:folder_one)

    visit project_folder_url(folder.project, folder)
    fill_in 'folder[name]', with: 'Folder name'
    click_button 'Créer'

    assert_text 'Dossier créé avec succès.'
    assert_text 'Folder name'
    assert folder.children.exists?
  end

  test 'deleting a folder' do
    project = projects(:pyramid)

    visit project_folder_url(project, project.root_folder)

    fill_in 'folder[name]', with: 'Folder name'
    click_button 'Créer'

    click_button(title: 'Supprimer ce dossier')

    assert_text 'Dossier supprimé avec succès.'
  end
end
