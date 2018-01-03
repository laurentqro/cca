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
end
