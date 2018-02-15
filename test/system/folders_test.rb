require "application_system_test_case"

class FoldersTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a subfolder' do
    folder = folders(:folder_one)
    folder.documents = []

    visit project_folder_url(folder.project, folder)
    fill_in 'subfolder[name]', with: 'Subfolder name'
    click_button 'Créer'

    assert_text 'Dossier créé avec succès.'
    assert_text 'Subfolder name'
  end
end
