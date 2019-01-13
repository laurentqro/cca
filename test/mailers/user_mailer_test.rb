require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    user = users(:one)
    email = UserMailer.welcome_email(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal [user.email], email.to
    assert_equal 'Bienvenue sur CCA', email.subject
    assert_includes email.html_part.body.to_s, user.first_name
    assert_includes email.html_part.body.to_s, "#{Rails.application.secrets[:host]}/auth/connexion"
  end

  test "new assignment" do
    user = users(:one)
    project = projects(:pyramid)
    assignment = Assignment.create(project_id: project.id, user_id: user.id)
    email = UserMailer.new_assignment(assignment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal [user.email], email.to
    assert_equal "Nouveau projet: The Great Pyramid of Gizeh", email.subject
    assert_includes email.html_part.body.to_s, "The Great Pyramid of Gizeh"
  end

  test "new_document" do
    user = users(:one)
    folder = folders(:folder_one)

    document = Document.create(
      folder: folder,
      user: user
    )

    document.file.attach(io: File.open('test/fixtures/files/pdf-sample.pdf'),
                         filename: 'pdf-sample.pdf',
                         content_type: 'application/pdf')


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
    assert_includes email.html_part.body.to_s, "#{activity.user.first_name}"
    assert_includes email.html_part.body.to_s, "#{activity.user.last_name}"
    assert_includes email.html_part.body.to_s, "#{activity.user.company.name}"
    assert_includes email.html_part.body.to_s, "#{activity.trackable.file.filename}"
  end

  test "invitation accepted" do
    invitee = users(:one)
    email = UserMailer.invitation_accepted(invitee)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Cabinet CCA admin@archicc.com', email.from
    assert_equal "#{invitee.full_name} a accepté votre invitation", email.subject
    assert_equal ['admin@archicc.com'], email.to
    assert_includes email.html_part.body.to_s, "#{invitee.full_name}"
    assert_includes email.html_part.body.to_s, "#{invitee.company.name}"
  end
end
