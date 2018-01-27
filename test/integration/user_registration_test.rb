require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest

  test 'user account registration' do
    user_params = {
      username: 'username',
      password: 'password',
      email: 'user@email.com',
      first_name: 'First Name',
      last_name: 'Last Name',
      city: 'City'
    }

    assert_difference 'ActionMailer::Base.deliveries.size' do
      post '/auth', params: { user: user_params }
    end

    welcome_email = ActionMailer::Base.deliveries.last

    assert_equal 'Bienvenue sur CCA', welcome_email.subject
    assert_equal 'user@email.com', welcome_email.to[0]
    assert_match(/Bienvenue sur CCA, First Name/, welcome_email.html_part.body.to_s)
    assert_match(/Bienvenue sur CCA, First Name/, welcome_email.text_part.body.to_s)
  end
end
