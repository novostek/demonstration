class CustomersController < ApplicationController
  #load_and_authorize_resource
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
      redirect_to @customer, alert: "#{note.errors.full_messages.to_sentence}"
    end


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
      redirect_to @customer, alert: "#{doc.errors.full_messages.to_sentence}"
    end

  end

  #Método que cria um novo contato
  def new_contact
    contact = Contact.new
    contact.title = params[:title]
    contact.category = params[:category]
    contact.data = params[:data]
    contact.origin = "Customer"
    contact.main = params[:main]
    contact.origin_id = @customer.id
    contact.main = params[:main]
    if contact.save
      redirect_to @customer, notice: "#{t 'contact_create'}"
    else
      redirect_to @customer, alert: "#{contact.errors.full_messages.to_sentence}"
    end

  end

  

  def search_customers
    @customers = Customer.where("name ilike ? ","%#{params[:search]}%")

    render "customers/index"
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
      if params[:button] == "remote_save"
        contact = Contact.new
        contact.title = 'Email'
        contact.category = 'email'
        contact.data = { email: params[:email] }
        contact.origin = "Customer"
        contact.main = true
        contact.origin_id = @customer.id
        contact.save
        contact = contact.dup
        contact.title = "Phone"
        contact.category = 'phone'
        contact.data = { phone: params[:phone] }
        contact.save
      end
      respond_to do |format|
        format.html { redirect_to @customer, notice: t('notice.customer.created') }
        format.json { render json: @customer }
      end
    else
      render :new
    end
  end
  #woffice_2020
  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: t('notice.customer.updated')
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: t('notice.customer.deleted')
  end

  def search_by_phone
    @customers = Customer.search_by_phone(params[:phone])
    render json: @customers
  end

  def search_by_email
    @customers = Customer.search_by_email(params[:email])
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
