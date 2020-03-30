class LaborCostsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_labor_cost, only: [:show, :edit, :update, :destroy,:new_note,:change_status,:new_document]


  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "LaborCost"
    note.origin_id = @labor_cost.id
    if note.save
      redirect_to costs_order_path(@labor_cost.schedule.origin_id), notice: "#{t 'note_create'}"
    else
      redirect_to costs_order_path(@labor_cost.schedule.origin_id), alert: "#{note.errors.full_messages.to_sentence}"
    end
  end

  def change_status
    @labor_cost.status = params[:status]
    if @labor_cost.save
      render json: {status: "ok", msg: "Changed to #{params[:status]}"}
    else
      render json: {status: "error", msg: @labor_cost.errors.full_message.to_sentence}
    end

  end


  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "LaborCost"
    doc.origin_id = @labor_cost.id
    if doc.save
      redirect_to costs_order_path(@labor_cost.schedule.origin_id), notice: "#{t 'doc_create'}"
    else
      redirect_to costs_order_path(@labor_cost.schedule.origin_id), alert: "#{note.errors.full_messages.to_sentence}"
    end

  end

  # GET /labor_costs
  def index
    @q = LaborCost.all.ransack(params[:q])
    @labor_costs = @q.result.page(params[:page])
  end

  # GET /labor_costs/1
  def show
  end

  # GET /labor_costs/new
  def new
    @labor_cost = LaborCost.new
  end

  # GET /labor_costs/1/edit
  def edit
  end

  # POST /labor_costs
  def create
    @labor_cost = LaborCost.new(labor_cost_params)

    if @labor_cost.save
      redirect_to @labor_cost, notice: 'Labor cost foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /labor_costs/1
  def update

    if @labor_cost.update(labor_cost_params)
      redirect = params[:redirect] || params[:labor_cost][:redirect]
      redirect_to redirect, notice: 'Labor cost was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /labor_costs/1
  def destroy
    @labor_cost.destroy
    redirect_to params[:redirect], notice: 'Labor cost was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_labor_cost
      @labor_cost = LaborCost.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def labor_cost_params
      params.require(:labor_cost).permit(:worker_id, :schedule_id, :date, :value, :status)
    end
end
