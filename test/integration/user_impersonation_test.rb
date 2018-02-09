require "application_system_test_case"

class UserImpersonationTest < ApplicationSystemTestCase
  test 'impersonating a user' do
    admin_user = users(:admin)
    partner = users(:partner)

    sign_in_as(admin_user)

    visit user_url(partner)

    click_on 'Se connecter en tant que Mike'

    assert_text 'Bonjour Mike'
  end
end
