class SendGridMail
  require 'sendgrid-ruby'
  include SendGrid

  require 'uri'
  require 'net/http'

  def self.get_templates
    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.templates.get({ query_params: { generations: 'dynamic' }})
    JSON.parse response.body
  end

  def self.encrypt(msg)
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.random_bytes(len)
    key   = ActiveSupport::KeyGenerator.new('W_o+o_f-i)c(e').generate_key(1, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(msg)
  end

  def self.decrypt(msg)
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.random_bytes(len)
    key   = ActiveSupport::KeyGenerator.new('W_o+o_f-i)c(e').generate_key(1, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(msg)
  end


  def  self.send_mail(template_id, objects, subject, emails)
    template_data = {}
    data = [] #Setting.get_value(send_from)
    template_data["subject"] = subject
    # binding.pry
    #monta o template data de acordo com os objetos passados em objects caso exista no json de setting
    # objects.each do |o|
    #   data["objects"].each do |ob|
    #     if ob["class"] == o.class.name
    #       ob["fields"].each do |field|
    #         template_data["#{field['sendgridkey']}"] = o.send(field["field"])
    #       end
    #     end
    #   end
    # end

    objects.each do |o|
      template_data["#{o.class.name.downcase}"] = o.attributes
    end

    mail = Mail.new
    mail.from = Email.new(email: emails)
    to = Email.new(email: emails)
    # subject = 'Sending with SendGridMail is Fun'
    # content = Content.new(type: 'text/html', value: 'and easy to do anywhere, even with Ruby {{teste_tag}}')

    personalization = Personalization.new
    personalization.add_to(to)
    personalization.add_dynamic_template_data(template_data)

    mail.add_personalization(personalization)
    mail.template_id = template_id  #data["template_id"]

    sg = SendGrid::API.new(api_key: Setting.get_value("send_grid_key"))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end


end