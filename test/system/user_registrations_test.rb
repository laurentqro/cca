require "application_system_test_case"

class UserRegistrationsTest < ApplicationSystemTestCase

  test 'creating a user registration' do
    visit new_user_registration_url

    fill_in 'user[username]', with: 'jonsnow'
    fill_in 'user[password]', with: 'iloveygritte'
    fill_in 'user[password_confirmation]', with: 'iloveygritte'
    fill_in 'user[email]', with: 'jon@winterfell.com'
    fill_in 'user[first_name]', with: 'Jon'
    fill_in 'user[last_name]', with: 'Snow'
    fill_in 'user[city]', with: 'Winterfell'

    click_button 'Valider'

    assert_text 'Bienvenue, vous êtes connecté.'
  end

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
