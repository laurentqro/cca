require "application_system_test_case"
require 'test_helper'

class UsersTest < ApplicationSystemTestCase
  test 'filtering users by project they are assigned to' do
    sign_in_as(users(:admin))
    visit users_url

    Assignment.create(user: users(:one), project: projects(:pyramid))
    Assignment.create(user: users(:two), project: projects(:colossus))

    fill_in "project_filter", with: "pyr"

    wait_for_ajax

    results = page.all('tbody tr')

    assert_equal(1, results.count)
    assert_text "Jon Snow"
  end

  test 'filtering users by companies they belong to' do
    sign_in_as(users(:admin))
    visit users_url

    fill_in "company_filter", with: "HBO"

    wait_for_ajax

    results = page.all('tbody tr')

    assert_equal(3, results.count)
    assert_text "Jon Snow"
  end

  test 'filtering users by querying the full name' do
    sign_in_as(users(:admin))
    visit users_url

    fill_in "user_filter", with: "Jon"

    wait_for_ajax

    results = page.all('tbody tr')

    assert_equal(1, results.count)
    assert_text "Jon Snow"
  end
end
