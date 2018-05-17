class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @login_url = new_user_session_url
    email_with_name = %("#{@user.full_name}" <#{@user.email}>)

    mail(
      to: email_with_name,
      subject: 'Bienvenue sur CCA'
    )
  end

  def new_document(activity)
    @activity = activity
    @document = activity.trackable
    @user = activity.user
    recipients = activity.project.subscribers.pluck(:email).reject { |email| email == @user.email }

    mail(
      to: ENV['SYSTEM_FROM_EMAIL'],
      bcc: recipients,
      subject: "Opération #{activity.project.name} - nouveau document"
    )
  end
end
