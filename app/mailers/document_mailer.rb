class DocumentMailer < ApplicationMailer

  def send_document
    attachments["document.pdf"] = WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: params[:emails], subject: params[:subject])
  end

  def send_invoice
    @order = params[:order]
    mail(to: params[:emails], subject: params[:subject])
  end

  def send_square
    @order = params[:order]
    @link = params[:link]

    attachments.inline['logo.png'] = File.read("#{Rails.root}/public/logo.png")

    if Rails.env.prodction?
      @url = "http://woodoffice.herokuapp.com/"
    else
      @url = "http://f5bbe7ed.ngrok.io"
    end


    mail(to: params[:emails], subject: "Payment of Order N* #{@order.code}")
  end


end
