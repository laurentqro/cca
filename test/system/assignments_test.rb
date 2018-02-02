require "application_system_test_case"

class AssignmentsTest < ApplicationSystemTestCase
  test 'adding a user to a project and then removing him' do
    sign_in_as(users(:admin))
    visit project_assignments_url(projects(:pyramid))
    find("#add_user_#{users(:one).id}").click

    assert page.has_selector?("#remove_user_#{users(:one).id}")
    assert page.has_no_selector?("#add_user_#{users(:one).id}")

    find("#remove_user_#{users(:one).id}").click

    assert page.has_no_selector?("#remove_user_#{users(:one).id}")
    assert page.has_selector?("#add_user_#{users(:one).id}")
  end
end
