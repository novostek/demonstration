class WorkersController < ApplicationController
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  # GET /workers
  def index
    @q = Worker.all.ransack(params[:q])
    @workers = @q.result.page(params[:page])
  end

  # GET /workers/1
  def show
  end

  # GET /workers/new
  def new
    @worker = Worker.new
  end

  # GET /workers/1/edit
  def edit
  end

  # POST /workers
  def create
    @worker = Worker.new(worker_params)

    if @worker.save
      redirect_to @worker, notice: 'Worker foi criado com sucesso'
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
      @worker = Worker.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def worker_params
      params.require(:worker).permit(:name, :photo, :document_id, :categories,
                                     notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                     document_files_attributes:[:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                     contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end

  #[:address,:zipcode,:zipcode,:state,:lat,:lng]
end
