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
    assert_equal ['no-reply@example.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Bienvenue sur CCA', email.subject
  end
end
