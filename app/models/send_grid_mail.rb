class SendGridMail
  require 'sendgrid-ruby'
  include SendGrid

  def self.teste
    from = Email.new(email: 'gabrielvash@gmail.com')
    to = Email.new(email: 'gabrielvash@gmail.com')
    subject = 'Sending with SendGridMail is Fun'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end