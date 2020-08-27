class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com',
          reply_to: Setting.get_value('company_email')

  layout 'mailer'
end
