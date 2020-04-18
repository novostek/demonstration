class SignaturesController < ApplicationController
  before_action :set_signature, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:create]
  #load_and_authorize_resource except: [:create]

  # GET /signatures
  def index
    @q = Signature.all.ransack(params[:q])
    @signatures = @q.result.page(params[:page])
  end

  # GET /signatures/1
  def show
  end

  # GET /signatures/new
  def new
    @signature = Signature.new
  end

  # GET /signatures/1/edit
  def edit
  end

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

  # POST /signatures
  def create

    @signature = Signature.new(signature_params)
    @signature.file = params[:signature][:file]
    #@signature.file.recreate_versions!

    if @signature.save
      if params[:signature][:sign].present?
        doc = DocumentFile.new
        doc.title = params[:signature][:doc_name] || "Signature"
        doc.origin = @signature.origin
        doc.origin_id = @signature.origin_id

        #cria a imagem temporária da assinatura
        temp = base64_to_file(params[:signature][:file])
        $temp_img = "/#{temp.path.split("/").last}"



        #cria o PDF
        #binding.pry
        if @signature.origin == "Estimate" and !params[:signature][:document].present?
          file = WickedPdf.new.pdf_from_url("#{Rails.configuration.woffice['url']}/estimates/#{@signature.origin_id}/estimate_signature?view=true")
        else
          file = WickedPdf.new.pdf_from_url("#{Rails.configuration.woffice['url']}/orders/doc_signature?document=#{params[:document] || params[:signature][:document]}")
        end

        # Write it to tempfile
        tempfile = Tempfile.new(['invoice', '.pdf'], Rails.root.join('tmp'))
        tempfile.binmode
        tempfile.write file
        tempfile.close

        doc.file = File.open(tempfile.path)
        doc.save
        if @signature.origin == "Estimate" and !params[:signature][:document].present?
          redirect_to "/estimates/#{@signature.origin_id}/estimate_signature?sign=true&view=true", notice: t('notice.signature.signed')
        else
          if !params[:signature][:mail].present? and params[:signature][:finish_order].present?
            redirect_to "/orders/#{@signature.origin_id}/finish"
          else
            #finaliza a order com a assinatura enviada por email

            if params[:signature][:customer_sign].present? and params[:signature][:customer_sign] == "true"
              begin
                Order.find(@signature.origin_id).update(status: :finished, end_at: Date.today)
              rescue
              end
            end

            redirect_to "/orders/doc_signature?document=#{params[:signature][:document]}"
          end
        end

      else
        redirect_to @signature, notice: t('notice.signature.created')
      end

    else
      render :new
    end
  end

  # PATCH/PUT /signatures/1
  def update
    @signature.origin = params[:signature][:origin]
    @signature.origin_id = params[:signature][:origin_id]
    @signature.file = params[:signature][:file]
    @signature.file.recreate_versions!
    if @signature.save
      redirect_to @signature, notice: t('notice.signature.updated')
    else
      render :edit
    end
  end

  # DELETE /signatures/1
  def destroy
    @signature.destroy
    redirect_to signatures_url, notice: t('notice.signature.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signature
      @signature = Signature.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def signature_params
      params.require(:signature).permit(:origin, :origin_id, :file)
    end
end
