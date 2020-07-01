class SignatureJob < ApplicationJob
  queue_as :default

  around_perform :around_cleanup

  def perform(job,signature_params, tenant)
    Apartment::Tenant.switch(tenant) do
    # Do something later
    doc = DocumentFile.new
    doc.title = signature_params[:signature][:doc_name] || "Signature"
    doc.origin = signature_params[:signature][:origin]
    doc.origin_id = signature_params[:signature][:origin_id]

    #cria a imagem temporária da assinatura
    temp = base64_to_file(signature_params[:signature][:file])
    $temp_img = "/#{temp.path.split("/").last}"

    url = Setting.url.sub "https", "http"

    #cria o PDF
    #binding.pry
    if signature_params[:signature][:origin] == "Estimate" and !signature_params[:signature][:document].present?
      file = WickedPdf.new.pdf_from_url("#{url}/estimates/#{signature_params[:signature][:origin_id]}/estimate_signature?view=true", {page_width: 1550, viewport_size: "1920x1080",print_media_type: true})
    else
      file = WickedPdf.new.pdf_from_url("#{url}/orders/doc_signature?document=#{signature_params[:document] || signature_params[:signature][:document]}", {page_width: 1550,  viewport_size: "1920x1080",print_media_type: true})
    end

    # Write it to tempfile
    tempfile = Tempfile.new(['invoice', '.pdf'], Rails.root.join('tmp'))
    tempfile.binmode
    tempfile.write file
    tempfile.close

    doc.file = File.open(tempfile.path)
    doc.save
    if signature_params[:signature][:origin] == "Estimate" and !signature_params[:signature][:document].present?
      job.redirect = "/estimates/#{signature_params[:signature][:origin_id]}/estimate_signature?sign=true&view=true"
    else
      if !signature_params[:signature][:mail].present? and signature_params[:signature][:finish_order].present?
        job.redirect = "/orders/#{signature_params[:signature][:origin_id]}/finish"
      else
        #finaliza a order com a assinatura enviada por email

        if signature_params[:signature][:customer_sign].present? and signature_params[:signature][:customer_sign] == "true"
          begin
            Order.find(signature_params[:signature][:origin_id]).update(status: :finished, end_at: Date.today)
          rescue
          end
        end

        job.redirect = "/orders/doc_signature?document=#{signature_params[:signature][:document]}"
      end
    end

    job.complete = true
    job.save
    end
  end

  private

  def base64_to_file(base64_data)
    return base64_data unless base64_data.is_a? String

    start_regex = /data:image\/[a-z]{3,4};base64,/
    filename ||= SecureRandom.hex

    regex_result = start_regex.match(base64_data)
    if base64_data && regex_result
      start = regex_result.to_s
      tempfile = Tempfile.new(['signature', '.jpg'], Rails.root.join('public'))
      tempfile.binmode
      tempfile.write(Base64.decode64(base64_data[start.length..-1]))
      # uploaded_file = ActionDispatch::Http::UploadedFile.new(
      #     :tempfile => tempfile,
      #     :filename => "signature.jpg",
      #     :original_filename => "signature.jpg"
      # )

      tempfile
    else
      nil
    end
  end

  def around_cleanup
    # Do something before perform
    yield
    # Do something after perform
  end
end
