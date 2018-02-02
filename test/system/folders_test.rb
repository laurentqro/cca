require "application_system_test_case"

class FoldersTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a folder' do
    visit project_url(projects(:pyramid))
    fill_in 'folder[name]', with: 'Folder name'
    click_button 'Créer'

    assert_text 'Dossier créé avec succès.'
    assert_text 'Folder name'
  end

  test 'creating a subfolder' do
    project = projects(:pyramid)
    folder = project.folders.create(name: "Foo")

    visit project_folder_url(project, folder)
    fill_in 'subfolder[name]', with: 'Subfolder name'
    click_button 'Créer'

    assert_text 'Sous-dossier créé avec succès.'
    assert_text 'Subfolder name'
  end
end
