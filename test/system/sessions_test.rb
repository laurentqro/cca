require "application_system_test_case"
require 'test_helper'

class SessionsTest < ApplicationSystemTestCase
  test 'logging in with username' do
    visit new_user_session_url

    fill_in 'user[email]', with: users(:one).username
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    assert_text 'Vous êtes connecté'
  end

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

    assert_text 'Identifiant ou mot de passe incorrect'
  end

  test "user directed to the page he intended to visit before being asked to sign in" do
    visit projects_path
    assert_current_path new_user_session_path

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    click_button 'Se connecter'

    assert_current_path projects_path
  end
end
