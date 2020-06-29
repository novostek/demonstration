class SuppliersController < ApplicationController
  load_and_authorize_resource
  before_action :set_supplier, only: [:show, :edit, :update, :destroy,:new_note,:new_document,:new_contact]

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Supplier"
    note.origin_id = @supplier.id
    if note.save
      redirect_to @supplier, notice: "#{t 'note_create'}"
    else
      redirect_to @supplier, alert: "error"
    end


  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "Supplier"
    doc.origin_id = @supplier.id
    if doc.save
      redirect_to @supplier, notice: "#{t 'doc_create'}"
    else
      redirect_to @supplier, alert: "error"
    end

  end

  #Método que cria um novo contato
  def new_contact
    contact = Contact.new
    contact.title = params[:title]
    contact.category = params[:category]
    contact.data = params[:data]
    contact.origin = "Supplier"
    contact.origin_id = @supplier.id
    contact.main = params[:main]
    if contact.save
      redirect_to @supplier, notice: "#{t 'contact_create'}"
    else
      redirect_to @supplier, alert: "error"
    end

  end

  # GET /suppliers
  def index
    @q = Supplier.all.order(name: :asc).where(active:true).ransack(params[:q])
    @suppliers = @q.result.page(params[:page])
  end

  # GET /suppliers/1
  def show
    if params[:layout].present?
      render :show_old
    end
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      if params[:button] != "remote_save"
        redirect_to @supplier, notice: t('notice.supplier.created')
      end
    else
      render :new
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: t('notice.supplier.updated')
    else
      render :edit
    end
  end

  # DELETE /suppliers/1
  def destroy
    @supplier.destroy
    redirect_to suppliers_url, notice: t('notice.supplier.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def supplier_params
      params.require(:supplier).permit(:name, :active, :description, notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                       document_files_attributes:[:description,:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                       contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end
end
