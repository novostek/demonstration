class DocumentMailer < ApplicationMailer

  def send_document
    attachments["document.pdf"] = WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: params[:emails], subject: "Teste pdf")
  end


end
