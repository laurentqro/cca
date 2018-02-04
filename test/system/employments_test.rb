require "application_system_test_case"

class EmploymentsTest < ApplicationSystemTestCase
  test 'adding a user to a company and then removing him' do
    sign_in_as(users(:admin))
    visit company_employments_url(companies(:cca))
    find("#add_user_#{users(:one).id}").click

    assert page.has_selector?("#remove_user_#{users(:one).id}")
    assert page.has_no_selector?("#add_user_#{users(:one).id}")

    find("#remove_user_#{users(:one).id}").click

    assert page.has_no_selector?("#remove_user_#{users(:one).id}")
    assert page.has_selector?("#add_user_#{users(:one).id}")
  end
end
