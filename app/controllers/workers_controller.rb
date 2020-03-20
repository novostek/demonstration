class WorkersController < ApplicationController
  before_action :set_worker, only: [:show, :edit, :update, :destroy,:new_note,:new_document,:new_contact,:update_contact]

  # GET /workers
  def index
    @q = Worker.all.ransack(params[:q])
    @workers = @q.result.page(params[:page])
  end

  # GET /workers/1
  def show
    if params[:layout].present?
      render :show_old
    end
  end

  # GET /workers/new
  def new
    @worker = Worker.new
  end

  # GET /workers/1/edit
  def edit
  end

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Worker"
    note.origin_id = @worker.id
    if note.save
      redirect_to @worker, notice: "#{t 'note_create'}"
    else
      redirect_to @worker, alert: "#{note.errors.full_messages.to_sentence}"
    end


  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "Worker"
    doc.origin_id = @worker.id
    if doc.save
      redirect_to @worker, notice: "#{t 'doc_create'}"
    else
      redirect_to @worker, alert: "#{doc.errors.full_messages.to_sentence}"
    end

  end

  #Método que cria um novo contato
  def new_contact
    contact = Contact.new
    contact.title = params[:title]
    contact.category = params[:category]
    contact.data = params[:data]
    contact.origin = "Worker"
    contact.origin_id = @worker.id
    contact.main = params[:main]
    if contact.save
      redirect_to @worker, notice: "#{t 'contact_create'}"
    else
      redirect_to @worker, alert: "#{contact.errors.full_messages.to_sentence}"
    end
  end



  # POST /workers
  def create
    @worker = Worker.new(worker_params)

    if @worker.save
      if params[:button] != "remote_save"
        redirect_to @worker, notice: 'Worker foi criado com sucesso'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /workers/1
  def update

    # if params[:value].present?
    #   value = JSON.parse(params[:value].to_json)
    #   params[:worker][:contacts_attributes][:value] = value
    # end
    #binding.pry
    if @worker.update(worker_params)
      redirect_to @worker, notice: 'Worker foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /workers/1
  def destroy
    @worker.destroy
    redirect_to workers_url, notice: 'Worker foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_worker
      @worker = Worker.includes(:contacts).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def worker_params
      params.require(:worker).permit(:name, :photo, :document_id, :categories,:time_value,
                                     notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                     document_files_attributes:[:description,:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                     contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end

  #[:address,:zipcode,:zipcode,:state,:lat,:lng]
end
