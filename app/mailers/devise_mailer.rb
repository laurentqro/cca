class DeviseMailer < Devise::Mailer
  include DefaultUrlOptions

  def reset_password_instructions(record, token, opts={})
    super
  end
end
