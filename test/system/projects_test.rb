require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a project' do
    visit new_project_url
    fill_in 'project[name]', with: 'The Great Wall of China'
    click_button 'Créer'

    assert_text 'Projet créé avec succès.'
  end

  test 'editing a project' do
    visit edit_project_url(projects(:pyramid))
    fill_in 'project[name]', with: 'The Colossus of Rhodes'
    click_on 'Valider'

    assert_text 'The Colossus of Rhodes'
    assert_text 'Modifications enregistrées.'
  end

  test 'deleting a project' do
    project = projects(:pyramid)
    visit project_folder_url(project, project.root_folder)
    click_on 'Supprimer'

    assert_text "Projet #{projects(:pyramid).name} supprimé."
  end

  test 'adding a project to the archives' do
    project = projects(:pyramid)
    visit project_folder_url(project, project.root_folder)
    click_on 'Archiver'

    assert_text "Projet #{project.name} archivé."
    assert_text  project.name
    assert_current_path archives_path
  end

  test 'removing a project from the archives' do
    project = projects(:pyramid)
    project.archived!
    visit project_folder_url(project, project.root_folder)
    click_on 'Désarchiver'

    assert_text "Projet #{project.name} désarchivé."
    assert_text project.name
    assert_current_path projects_path
  end
end
