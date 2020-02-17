class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy,:new_note,:new_document,:new_contact]

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Customer"
    note.origin_id = @customer.id
    if note.save
      redirect_to @customer, notice: "#{t 'note_create'}"
    else
      redirect_to @customer, alert: "error"
    end


  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.origin = "Customer"
    doc.origin_id = @customer.id
    if doc.save
      redirect_to @customer, notice: "#{t 'doc_create'}"
    else
      redirect_to @customer, alert: "error"
    end

  end

  #Método que cria um novo contato
  def new_contact
    contact = Contact.new
    contact.title = params[:title]
    contact.category = params[:category]
    contact.data = params[:data]
    contact.origin = "Customer"
    contact.origin_id = @customer.id
    if contact.save
      redirect_to @customer, notice: "#{t 'contact_create'}"
    else
      redirect_to @customer, alert: "error"
    end

  end

  # GET /customers
  def index
    @q = Customer.all.ransack(params[:q])
    @customers = @q.result.page(params[:page])
  end

  # GET /customers/1
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: 'Customer foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: 'Customer foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.require(:customer).permit(:name, :category, :document_id, :since, :code, :birthdate, notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                       document_files_attributes:[:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                       contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end
end
