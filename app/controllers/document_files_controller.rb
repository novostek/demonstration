class DocumentFilesController < ApplicationController
  before_action :set_document_file, only: [:show, :edit, :update, :destroy]

  # GET /document_files
  def index
    @q = DocumentFile.all.ransack(params[:q])
    @document_files = @q.result.page(params[:page])
  end

  # GET /document_files/1
  def show
  end

  # GET /document_files/new
  def new
    @document_file = DocumentFile.new
  end

  # GET /document_files/1/edit
  def edit
  end

  # POST /document_files
  def create
    @document_file = DocumentFile.new(document_file_params)

    if @document_file.save
      redirect_to @document_file, notice: 'Document file foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /document_files/1
  def update
    if @document_file.update(document_file_params)
      redirect_to @document_file, notice: 'Document file foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /document_files/1
  def destroy
    @document_file.destroy
    redirect_to document_files_url, notice: 'Document file foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_file
      @document_file = DocumentFile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def document_file_params
      params.require(:document_file).permit(:title, :file, :origin, :origin_id, :esign, :esign_data, :photo, :photo_date, :photo_description)
    end
end
