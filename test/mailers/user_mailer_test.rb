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

  test "new_document" do
    user = users(:one)
    folder = folders(:folder_one)

    s3_url = %r{https://#{ENV['AWS_S3_BUCKET']}.s3.#{ENV['AWS_S3_REGION']}.amazonaws.com}
    stub_request(:put, s3_url).to_return(body: '', status: 200)

    document = Document.create(
      file: File.open('test/fixtures/files/pdf-sample.pdf'),
      folder: folder,
      user: user
    )

    activity = user.activities.create(action: "create",
                                     trackable: document,
                                     project:   folder.project,
                                     folder:    folder)

    folder.project.subscribers << users(:one)
    folder.project.subscribers << users(:two)

    email = UserMailer.new_document(activity)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal ['admin@archicc.com'], email.to
    assert_equal [users(:two).email], email.bcc
    assert_equal "Opération #{activity.project.name} - nouveau document", email.subject
    assert_includes email.html_part.body.to_s, "#{activity.user.full_name}"
    assert_includes email.html_part.body.to_s, "#{activity.user.company.name}"
    assert_includes email.html_part.body.to_s, "#{activity.trackable.file.original_filename}"
  end
end
