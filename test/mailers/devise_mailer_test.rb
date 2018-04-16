require 'test_helper'

class DeviseMailerTest < ActionMailer::TestCase
  test "password reset instructions email" do
    user = users(:one)
    token = "foo"
    email = DeviseMailer.reset_password_instructions(user, token)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal "Instructions pour changer votre mot de passe", email.subject
  end
end
