require "application_system_test_case"
require 'test_helper'

class SessionsTest < ApplicationSystemTestCase
  test 'logging in with email' do
    visit new_user_session_url

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    assert_text 'Vous êtes connecté'
  end

  test 'failed login attempt' do
    visit new_user_session_url

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'wrong password'

    click_button 'Se connecter'

    assert_text 'Email ou mot de passe incorrect'
  end

  test 'logged in user who visits the log in page is taken to the homepage' do
    visit new_user_session_url

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    visit new_user_session_url

    assert_current_path root_path
  end

  test 'user directed to the page he intended to visit before being asked to sign in' do
    visit projects_path
    assert_current_path new_user_session_path

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    assert_current_path projects_path
  end

  test 'inactive user account is not authorised to sign in' do
    user = users(:one)
    user.update(active: false)

    visit new_user_session_url

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    assert_current_path new_user_session_path
    assert_text %{Votre compte n'est pas activé. Si vous pensez que c'est une erreur, contactez l'administrateur.}
  end

  test 'logged in user is shown his user privilege group' do
    visit new_user_session_url

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    visit new_user_session_url

    assert_text "Utilisateur"
  end
end
