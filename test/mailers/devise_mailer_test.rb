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

  test "invitations instructions email" do
    user = users(:one)
    project = projects(:pyramid)
    token = "foo"
    Assignment.create(project_id: project.id, user_id: user.id)

    email = DeviseMailer.invitation_instructions(user, token)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal [user.email], email.to
    assert_equal 'Votre invitation à CCA', email.subject
    assert_includes email.html_part.body.to_s, project.name
  end
end
