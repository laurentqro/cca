class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @login_url = new_user_session_url

    mail(
      to: email_with_name(@user),
      subject: 'Bienvenue sur CCA'
    )
  end

  def new_document(activity)
    @activity = activity
    @document = activity.trackable
    @user = activity.user
    recipients = activity.project.subscribers.pluck(:email).reject { |email| email == @user.email }

    mail(
      to: ENV['SYSTEM_TO_EMAIL'],
      bcc: recipients,
      subject: "Opération #{activity.project.name} - nouveau document"
    )
  end

  def invitation_accepted(invitee)
    @invitee = invitee

    mail(
      to: ENV['SYSTEM_TO_EMAIL'],
      subject: "#{invitee.full_name} a accepté votre invitation"
    )
  end

  def new_assignment(assignment)
    @project = assignment.project

    mail(
      to: email_with_name(assignment.user),
      subject: "Nouveau projet: #{@project.name}"
    )
  end

  private

  def email_with_name(user)
    %("#{user.full_name}" <#{user.email}>)
  end
end
