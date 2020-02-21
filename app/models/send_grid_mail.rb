class SendGridMail
  require 'sendgrid-ruby'
  include SendGrid

  require 'uri'
  require 'net/http'

  def self.get_template
    url = URI("https://api.sendgrid.com/v3/designs/d-209a08276e804f778e57cefb058b52d1")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["authorization"] = Setting.get_value("send_grid_key")
    request.body = "{}"

    response = http.request(request)
    puts response.read_body
  end

  def self.teste
    from = Email.new(email: 'gabrielvash@gmail.com')
    to = Email.new(email: 'gabrielvash@gmail.com')
    subject = 'Sending with SendGridMail is Fun'
    content = Content.new(type: 'text/html', value: 'and easy to do anywhere, even with Ruby {{teste_tag}}')
    mail = Mail.new(from, subject, to, content)

    personalization = Personalization.new
    personalization.add_substitution(Substitution.new(key: '{{teste_tag}}', value: "teste substituicao"))
    personalization.add_to(to)
    mail.add_personalization(personalization)

    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def  self.teste_template
    mail = Mail.new
    mail.from = Email.new(email: 'gabrielvash@gmail.com')
    to = Email.new(email: 'gabrielvash@gmail.com')
    subject = 'Sending with SendGridMail is Fun'
    content = Content.new(type: 'text/html', value: 'and easy to do anywhere, even with Ruby {{teste_tag}}')


    personalization = Personalization.new
    #personalization.add_substitution(Substitution.new(key: '{{teste_tag}}', value: "teste substituicao"))
    personalization.add_to(to)
    personalization.add_dynamic_template_data({
                                                  "subject" => "Testing Templates",
                                                  "teste_tag" => "Example User",
                                                  "city" => "Denver"
                                              })
    mail.add_personalization(personalization)
    mail.template_id = 'd-209a08276e804f778e57cefb058b52d1'
    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def  self.send_mail(send_from, objects, subject)
    template_data = {}
    data = Setting.get_value(send_from)
    template_data["subject"] = subject
    # binding.pry
    #monta o template data de acordo com os objetos passados em objects caso exista no json de setting
    objects.each do |o|
      data["objects"].each do |ob|
        if ob["class"] == o.class.name
          ob["fields"].each do |field|
            template_data["#{field['sendgridkey']}"] = o.send(field["field"])
          end
        end
      end
    end

    objects.each do |o|

      template_data["#{o.class.name.downcase}"] = o.attributes

    end

    # objects.each do |o|
    #   o.attributes.keys.each do |key|
    #     template_data["#{o.class.name.downcase}_#{key}"] = o.send(key)
    #   end
    # end

    mail = Mail.new
    mail.from = Email.new(email: 'gabrielvash@gmail.com')
    to = Email.new(email: 'gabrielvash@gmail.com')
    subject = 'Sending with SendGridMail is Fun'
    content = Content.new(type: 'text/html', value: 'and easy to do anywhere, even with Ruby {{teste_tag}}')


    personalization = Personalization.new

    personalization.add_to(to)
    personalization.add_dynamic_template_data(template_data)
    mail.add_personalization(personalization)
    mail.template_id = data["template_id"]
    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def self.substituir
    Substitution.new(key: '%name%', value: 'Example User')
  end



  def self.test_plutus
    entry = Plutus::Entry.new(
        :description => "Order placed for widgets",
        :date => Date.yesterday,
        :debits => [
            {:account_name => "Teste", :amount => 100.00}],
        :credits => [
            {:account_name => "Teste", :amount => 100.00}])

    entry.save
  end
end