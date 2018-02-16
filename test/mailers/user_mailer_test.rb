require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    # Create the email and store it for further assertions
    user = users(:one)
    email = UserMailer.welcome_email(user)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal [user.email], email.to
    assert_equal 'Bienvenue sur CCA', email.subject
    assert_includes email.html_part.body.to_s, user.first_name
    assert_includes email.html_part.body.to_s, "#{Rails.application.secrets[:host]}/auth/connexion"
  end
end
