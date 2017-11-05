require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test 'creating a user' do
    visit new_user_url

    fill_in 'user[username]', with: 'jonsnow'
    fill_in 'user[password]', with: 'iloveygritte'
    fill_in 'user[email]', with: 'jon@winterfell.com'
    fill_in 'user[first_name]', with: 'Jon'
    fill_in 'user[last_name]', with: 'Snow'
    fill_in 'user[company]', with: 'Whitewalker Killerz Inc.'
    fill_in 'user[city]', with: 'Winterfell'

    click_button 'Créer'

    assert_text 'Compte créé avec succès.'
  end

  test 'editing a user' do
    visit edit_user_url(users(:one))
    fill_in 'user[username]', with: 'jontargaryen'
    click_on 'Valider'

    assert_text 'jontargaryen'
    assert_text 'Modifications enregistrées.'
  end

  test 'deleting a user' do
    visit user_url(users(:one))
    click_on 'Supprimer ce compte'

    assert_text "Compte #{users(:one).username} supprimé."
  end

  test 'making a user inactive' do
    user = users(:one)
    visit edit_user_url(user)
    uncheck 'Actif'
    click_on 'Valider'
    assert_not user.reload.active?
  end
end
