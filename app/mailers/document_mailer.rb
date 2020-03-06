class DocumentMailer < ApplicationMailer

  def send_document
    attachments["document.pdf"] = WickedPdf.new.pdf_from_string(params[:pdf])
    mail(to: "gabrielvash@gmail.com", subject: "Teste pdf")
  end


end
