class ApplicationMailer < ActionMailer::Base
  default from: ENV["SYSTEM_FROM_EMAIL"]
  layout 'mailer'
end
