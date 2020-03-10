class DocumentMailer < ApplicationMailer

  def send_document
    attachments["document.pdf"] = WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: params[:emails], subject: params[:subject])
  end

  def send_square
    @order = params[:order]
    @link = params[:link]
    mail(to: params[:emails], subject: "Payment of Order N* #{order.code}")
  end


end
