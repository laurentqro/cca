require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test 'logging in with username' do
    visit log_in_url

    fill_in 'session[identifier]', with: users(:one).username
    fill_in 'session[password]', with: 'password'

    click_button 'Connexion'

    assert_text 'Vous êtes connecté'
  end

  test 'logging in with email' do
    visit log_in_url

    fill_in 'session[identifier]', with: users(:one).email
    fill_in 'session[password]', with: 'password'

    click_button 'Connexion'

    assert_text 'Vous êtes connecté'
  end

  test 'failed login attempt' do
    visit log_in_url

    fill_in 'session[identifier]', with: users(:one).email
    fill_in 'session[password]', with: 'wrong_password'

    click_button 'Connexion'

    assert_text 'Identifiant ou mot de passe incorrect'
  end
end
