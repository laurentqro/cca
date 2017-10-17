require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "creating a user" do
    visit new_user_url

    fill_in 'user[username]', with: 'jonsnow'
    fill_in 'user[password]', with: 'iloveygritte'
    fill_in 'user[email]', with: 'jon@winterfell.com'
    fill_in 'user[first_name]', with: 'Jon'
    fill_in 'user[last_name]', with: 'Snow'
    fill_in 'user[company]', with: 'Whitewalker Killerz Inc.'
    fill_in 'user[city]', with: 'Winterfell'

    click_button 'Creer'

    assert_selector "body", text: "Utilisateur cree avec succes."
  end
end
