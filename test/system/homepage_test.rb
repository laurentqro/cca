require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
  test 'visiting the homepage' do
    visit root_url
    assert_selector 'h1', text: 'Accueil - CCA'
  end
end
