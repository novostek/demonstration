class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

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

  end

  def preview

    has_custom_field = false
    @customs = []
    @params = {}

    if params[:estimate].present?
      @estimate = Estimate.find(params[:estimate])
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


    if has_custom_field
      if params[:estimate].present?
        redirect_to send_customs_documents_path(estimate: params[:estimate], document: params[:document], customs: @customs)
      else
        redirect_to send_customs_documents_path(document: params[:document], customs: @customs)
      end

    end

    @template = Liquid::Template.parse(@data)

    if params[:custom_send].present?
      emails = ["gabrielvash@gmail.com"]
      begin
        DocumentMailer.with(emails: emails, pdf: @template.render('estimate' => @estimate.attributes, 'measurements' => JSON.parse(@estimate.measurement_areas.to_json), 'customer' => @estimate.customer.attributes, 'custom' => @params, 'signature' => JSON.parse(@estimate.signatures.last.to_json)   )).send_document.deliver_now
      rescue

      end
    end

    respond_to do |format|
      format.html
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

  #Método que salva os dados do froala
  def save_data
    #binding.pry
    document = Document.find(params[:document])
    document.data = params[:data]
    document.save
    render json: {success:"Success"}
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
      redirect_to @document, notice: 'Document foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
    redirect_to documents_url, notice: 'Document foi apagado com sucesso.'
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
