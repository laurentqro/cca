require "application_system_test_case"

class UserPermissionsTest < ApplicationSystemTestCase
  test 'partner can only access a project he is assigned to' do
    sign_in_as(users(:one))
    project = projects(:pyramid)
    visit project_url(project)

    assert_text "Accès non autorisé"
  end

  test 'partner can only view the list of projects he is assigned to' do
    user = users(:one)
    sign_in_as(user)
    user_project = projects(:pyramid)
    forbidden_project = projects(:colossus)

    Assignment.create(project_id: user_project.id,
                      user_id: user.id)

    visit projects_url

    assert page.has_content?(user_project.name)
    assert !page.has_content?(forbidden_project.name)
  end

  test 'partner cannot view list of all users' do
    user = users(:one)
    sign_in_as(user)
    visit users_url

    assert_text "Accès non autorisé"
  end

  test 'partner cannot create or delete project assignments' do
    project = projects(:pyramid)
    user = users(:one)
    sign_in_as(user)
    visit project_url(project)

    assert !page.has_content?("ajouter")
    assert !page.has_content?("retirer")
  end

  test 'employee can view list of all projects' do
    project = projects(:pyramid)
    another_project = projects(:colossus)
    user = users(:one)
    user.employee!
    sign_in_as(user)

    visit projects_url

    assert_text project.name
    assert_text another_project.name
  end

  test 'employee can view list of all users' do
    user = users(:one)
    other_user = users(:two)
    user.employee!
    sign_in_as(user)

    visit users_url

    assert_text "#{user.full_name}"
    assert_text "#{other_user.full_name}"
  end

  test 'employee can view all projects' do
    user = users(:one)
    user.employee!
    sign_in_as(user)

    other_user = users(:two)
    project = projects(:pyramid)
    Assignment.create(user: other_user, project: project)

    visit project_url(project)

    assert_text project.name
  end
end
