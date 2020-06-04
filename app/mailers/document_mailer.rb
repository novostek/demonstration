class DocumentMailer < ApplicationMailer
  after_action :set_smtp

  #Método de envio do estimate
  def send_estimate_mail
    @link = params[:link]
    @estimate = params[:estimate]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    mail(to: params[:emails], subject: params[:subject])
  end

  #Método de envio do email com os documentos
  def send_document

    @customer = params[:customer]
    @doc = params[:doc]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    attachments["document.pdf"] = WickedPdf.new.pdf_from_url("#{Setting.url.sub "https", "http"}/orders/doc_signature?document=#{@doc.id}", {page_size: "A3"}) #WickedPdf.new.pdf_from_string(params[:pdf])
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

    mail(to: params[:emails], subject: "Payment of Order N* #{@order.code}")
  end

  #Método de envio de email com a confirmação do schedule
  def send_schedule_mail
    @schedule = params[:schedule]
    @customer = params[:customer]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: "Schedule confirmation")
  end

  private

  def set_smtp
    smtp_settings  = {
        :address => Setting.get_value("mail_address").present? ? Setting.get_value("mail_address") : "smtp.gmail.com", :port => Setting.get_value("mail_port").present? ? Setting.get_value("mail_port").to_i : 587,
        #:domain => Setting.url,
        :authentication => 'plain',
        :user_name => Setting.get_value("mail_user").present? ? Setting.get_value("mail_user") : 'wofficemail@gmail.com',
        :password => Setting.get_value("mail_password").present? ? Setting.get_value("mail_password") : 'woffice_2020',
        :enable_starttls_auto => true
    }
    mail.delivery_method.settings.merge!(smtp_settings)

  end


end
