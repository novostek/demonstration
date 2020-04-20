class DocumentsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_document, only: [:show, :edit, :update, :destroy,:add_custom]



  # GET /documents
  def index
    @q = Document.all.ransack(params[:q])
    @documents = @q.result.page(params[:page])
  end

  # GET /documents/1
  def show
  end

  def send_customs
    @estimate = params[:estimate]
    @document = params[:document]
    @customs = params[:customs]
    @send_mail = params[:send_mail]
    @emails = params[:emails]
    @from = params[:from]
    @customer_sign = params[:customer_sign]
    @redirect = params[:redirect]
    @finish_order = params[:finish_order]
  end

  def add_custom
    @custom = DocumentCustomField.new
    @custom.name = params[:name]
    @custom.document = @document
    @custom.save
    respond_to do |format|
      format.js
    end
  end

  def send_mail

  end

  def preview

    @mail = nil
    has_custom_field = false
    @customs = []
    @params = {}
    @customer_sign = params[:customer_sign] || false
    @finish_order = params[:finish_order] || false

    if params[:estimate].present?
      @estimate = Estimate.find(params[:estimate])
    end

    if !params[:document].present?
      redirect_to "/estimates/#{@estimate.id}/view", notice: "Inform Document"
      return
    end

    @document = Document.find(params[:document])

    @data = @document.data

    #faz a verificação dos customs caso não estejam preenchidos
    if !params[:custom_send].present?
      @document.document_custom_fields.each do |d|
        if @data.scan(/(?=#{"{{custom.#{d.name}}"})/).count > 0
          has_custom_field = true
          @customs << "#{d.name}"
        end
      end
    else
      params[:customs].each do |p|
        @params["#{p[0]}"] = "#{p[1]}"
      end

    end

    begin
      @order_params = @estimate.order.attributes
    rescue
      @order_params = {}
      @order_params["key"] = "value"
    end



    if has_custom_field
      if params[:estimate].present?
        redirect_to send_customs_documents_path(finish_order: @finish_order,redirect: preview_documents_path ,customer_sign: @customer_sign, from: params[:from],estimate: params[:estimate], document: params[:document], customs: @customs, send_mail: params[:send_mail],emails: params[:emails],subject: params[:subject])
        #return
      else
        redirect_to send_customs_documents_path(finish_order: @finish_order,redirect: preview_documents_path ,customer_sign: @customer_sign,from: params[:from],document: params[:document], customs: @customs, send_mail: params[:send_mail],emails: params[:emails],subject: params[:subject])
        #return
      end

    else

      @template = Liquid::Template.parse(ERB.new(@data).result(binding))

      if params[:from] == "Estimate"
        origin_id = @estimate.id
      else
        origin_id = @estimate.order.id
      end

      if params[:send_mail].present? and params[:send_mail] == "true"
        emails = params[:emails]
        #begin
          puts "Enviando email"


          doc = DocumentSend.new(origin: params[:from],origin_id: origin_id, data: @template.render('order' => @order_params ,'estimate' => @estimate.attributes, 'measurements' => JSON.parse(@estimate.measurement_areas.to_json), 'products' => JSON.parse(@estimate.product_estimates.to_json), 'customer' => JSON.parse(@estimate.customer.to_json), 'custom' => @params   ) )
          doc.save
          DocumentMailer.with( link: "#{Setting.url}#{doc_signature_mail_orders_path(customer_sign: @customer_sign, document: doc.id,doc_name: @document.name)}" , doc: doc, customer: @estimate.customer ,subject: params[:subject], emails: emails, pdf: @template.render('order' => @order_params,'estimate' => @estimate.attributes, 'measurements' => JSON.parse(@estimate.measurement_areas.to_json), 'products' => JSON.parse(@estimate.product_estimates.to_json), 'customer' => JSON.parse(@estimate.customer.to_json), 'custom' => @params   )).send_document.deliver_now #, 'signature' => JSON.parse(@estimate.signatures.last.to_json)
        #rescue
          puts "Enviando erro"
        #end
      end
      #Assinatura a finalização da order
      if params[:finish_order].present? and params[:finish_order] == "true"
        doc = DocumentSend.new(origin: params[:from],origin_id: origin_id, data: @template.render('order' => @order_params ,'estimate' => @estimate.attributes, 'measurements' => JSON.parse(@estimate.measurement_areas.to_json), 'products' => JSON.parse(@estimate.product_estimates.to_json), 'customer' => JSON.parse(@estimate.customer.to_json), 'custom' => @params   ) )
        doc.save
        redirect_to doc_signature_mail_orders_url(customer_sign: @customer_sign, document: doc.id,doc_name: @document.name)
        return
      end

      respond_to do |format|
        format.html {
          if params[:send_mail].present? and params[:send_mail] == "true"
            toastr("success","Mail Sent")
          end
        }
        format.pdf do
          render pdf: "#{@document.name}",
                 page_size: 'A4',
                 template: "documents/preview.html.erb",
                 layout: "pdf.html",
                 orientation: "Portrait",
                 lowquality: true,
                 zoom: 1,
                 dpi: 75
        end
      end
    end
  end

  #Método que salva os dados do froala
  def save_data
    #binding.pry
    document = Document.find(params[:document])
    document.data = params[:data]
    document.save
    render json: {success:"Document Saved"}
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      redirect_to @document, notice: t('notice.document.created')
    else
      render :new
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      redirect_to @document, notice: t('notice.document.updated')
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
    redirect_to documents_url, notice: t('notice.document.deleted')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def document_params
    params.require(:document).permit(:name, :description, :data, :doc_type, :sub_type,document_custom_fields_attributes:[:id, :document_id,:name,:_destroy])
  end
end
