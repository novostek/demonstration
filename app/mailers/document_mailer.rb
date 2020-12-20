class DocumentMailer < ApplicationMailer
  after_action :set_smtp

  #Método de envio do estimate
  def send_estimate_mail
    @link = params[:link]
    @estimate = params[:estimate]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    mail(to: params[:emails], subject: params[:subject])
  end

  #Método que envia o email solicitando o cadastro do cartão
  def mail_card
    @customer = params[:customer]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    mail(to: params[:emails], subject: params[:subject])#,delivery_method_options: smtp_settings
  end

  # Avisa o client que seu cartão foi registrado
  def send_card_added_successfully
    @customer = Customer.find(params[:customer])
    @link = "#{Setting.url}/square_api/index_cards?customer=#{@customer.id}&from=email"
    @card = params[:card]

    mail(to: @customer.temporary_email, subject: t('texts.document_mailer.card_successfully_added'))
  end

  #Método de envio do email com os documentos
  def send_document

    @customer = params[:customer]
    @doc = params[:doc]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    attachments["document.pdf"] = WickedPdf.new.pdf_from_url("#{Setting.url}/orders/doc_signature?document=#{@doc.id}", {page_size: "A3"}) #WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: params[:emails], subject: params[:subject])#,delivery_method_options: smtp_settings
  end

  #Método de envio de email com a invoice
  def send_invoice
    @link = params[:link]
    @order = params[:order]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    mail(to: params[:emails], subject: params[:subject])
  end

  #Método de envio de email para finalização da order
  def sign_order
    @order = params[:order]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: params[:subject])
  end

  #Método de envio de email com o checkout da square
  def send_square
    @order = params[:order]
    @link = params[:link]
    @transaction = params[:transaction]

    attachments.inline['square.png'] = File.read("#{Rails.root}/public/logo.png")
    attachments.inline['woffice.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: "#{t 'texts.document_mailer.payment_of_order_n'} #{@order.code}")
  end

  #Método de envio de email com a confirmação do schedule
  def send_schedule_mail
    @schedule = params[:schedule]
    @customer = params[:customer]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: t('texts.document_mailer.schedule_confirmation'))
  end

  #Método de envio do estimate assinado pelo cliente
  def send_signed_estimate_mail
    @estimate = params[:estimate]
    mail(to: Setting.get_value("mail_address").present? ? Setting.get_value("company_email") : "smtp.gmail.com",
         subject: "#{@estimate.customer.name.split.first} #{t 'texts.document_mailer.approved_the_estimate_n'} #{@estimate.code}")
  end

  # Avisa a empresa que recebeu pagamento via square
  def send_square_paid_company
    #binding.pry
    @transaction = params[:transaction]
    mail(to: Setting.get_value("mail_address").present? ? Setting.get_value("company_email") : "smtp.gmail.com",
         subject: t('texts.document_mailer.payment_received_by_square'))
  end

  # Avisa o cliente que seu pagamento foi registrado
  def send_transaction_paid_customer
    @transaction = params[:transaction]
    @customer = @transaction.customer

    mail(to: @customer.get_main_email_f,
         subject: t('texts.document_mailer.your_payment_has_been_registered_with_the_woffice'))
  end

  # Avisa a empresa que o cliente rejeitou estimate
  def send_decline_estimate
    @estimate = params[:estimate]
    @reason = params[:reason]
    mail(to: Setting.get_value("company_email"),
         subject: "One customer rejected estimate")
  end

  # Avisa o trabalhador que foi feito um agendamento para ele
  def send_schedule_mail_to_worker
    @schedule = params[:schedule]
    @worker = params[:worker]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: "Schedule confirmation")
  end

  private

  def set_smtp
    smtp_settings  = {
        :address => Setting.get_value("mail_address").present? ? Setting.get_value("mail_address") : "smtp.gmail.com", :port => Setting.get_value("mail_port").present? ? Setting.get_value("mail_port").to_i : 587,
        #:domain => Setting.url,
        :authentication => 'plain',
        :user_name => Setting.get_value("mail_user").present? ? Setting.get_value("mail_user") : 'no-reply@woffice.app',
        :password => Setting.get_value("mail_password").present? ? Setting.get_value("mail_password") : 'Woffice2020',
        :enable_starttls_auto => true
    }
    mail.delivery_method.settings.merge!(smtp_settings)

  end


end
