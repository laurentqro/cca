require "application_system_test_case"

class CompaniesTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'creating a company' do
    visit new_company_url
    fill_in 'company[name]', with: 'Acme, Inc.'
    click_button 'Créer'

    assert_text 'Groupe créé avec succès.'
  end

  test 'editing a company' do
    visit edit_company_url(companies(:cca))
    fill_in 'company[name]', with: 'Foo'
    click_on 'Valider'

    assert_text 'Foo'
    assert_text 'Modifications enregistrées.'
  end
end
