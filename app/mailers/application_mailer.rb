class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets[:system_from_email]
  layout 'mailer'
end
