require "application_system_test_case"

class FoldersTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a folder' do
    folder = folders(:folder_one)
    folder.documents = []

    visit project_folder_url(folder.project, folder)
    fill_in 'folder[name]', with: 'Folder name'
    click_button 'Créer'

    assert_text 'Dossier créé avec succès.'
    assert_text 'Folder name'
  end
end
