class DocumentMailer < ApplicationMailer

  def send_document
    @customer = params[:customer]
    @doc = params[:doc]
    @link = params[:link]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    attachments["document.pdf"] = WickedPdf.new.pdf_from_url("#{Rails.configuration.woffice['url']}/orders/doc_signature?document=#{@doc.id}") #WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: params[:emails], subject: params[:subject])
  end

  def send_invoice
    @link = params[:link]
    @order = params[:order]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")
    mail(to: params[:emails], subject: params[:subject])
  end

  def sign_order
    @order = params[:order]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/woffice.png")

    mail(to: params[:emails], subject: params[:subject])
  end

  def send_square
    @order = params[:order]
    @link = params[:link]
    @transaction = params[:transaction]

    attachments.inline['square.png'] = File.read("#{Rails.root}/public/logo.png")
    attachments.inline['woffice.png'] = File.read("#{Rails.root}/public/woffice.png")

    if Rails.env.prodction?
      @url = "#{Rails.configuration.woffice['url']}"
    else
      @url = "http://f5bbe7ed.ngrok.io"
    end


    mail(to: params[:emails], subject: "Payment of Order N* #{@order.code}")
  end


end
