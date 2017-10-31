require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  test 'creating a project' do
    visit new_project_url
    fill_in 'project[name]', with: 'The Great Wall of China'
    click_button 'Créer'

    assert_text 'Projet créé avec succès.'
  end

  test 'editing a project' do
    visit edit_project_url(projects(:one))
    fill_in 'project[name]', with: 'The Colossus of Rhodes'
    click_on 'Valider'

    assert_text 'The Colossus of Rhodes'
    assert_text 'Modifications enregistrées.'
  end

  test 'deleting a project' do
    visit project_url(projects(:one))
    click_on 'Supprimer ce projet'

    assert_text "Projet #{projects(:one).name} supprimé."
  end
end
