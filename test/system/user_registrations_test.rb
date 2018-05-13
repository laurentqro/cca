require "application_system_test_case"

class UserRegistrationsTest < ApplicationSystemTestCase
  test 'editing a user registration' do
    user = users(:one)
    sign_in_as(user)

    visit edit_user_registration_url
    fill_in 'user[city]', with: 'Westeros'
    fill_in 'user[current_password]', with: 'password'
    click_on 'Valider'

    assert_text 'Votre compte a été modifié avec succès'
  end
end
