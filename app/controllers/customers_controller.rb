class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy,:new_note,:new_document,:new_contact]
  #skip_before_action :authenticate_user!, only: [:process_payment]


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

  def checkout
    checkout_status, checkout_data = SquareApi.create_checkout
    if checkout_status
      redirect_to checkout_data[:checkout][:checkout_page_url]
    else
      redirect_to process_payment_customers_path
    end

  end

  def process_payment
    #binding.pry
    result = SquareApi.create_payment(params[:nonce],1000)
    binding.pry
  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
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
      if params[:button] != "remote_save"
        redirect_to @customer, notice: 'Customer foi criado com sucesso'
      end
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

  def search_by_phone
    @customers = Customer.search_by_phone(params[:phone])
    render json: @customers
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.require(:customer).permit(:name, :category, :document_id, :since, :code, :birthdate, notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                       document_files_attributes:[:description,:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                       contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end
end
