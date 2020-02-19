class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]

  # GET /estimates
  def index
    @q = Estimate.all.ransack(params[:q])
    @estimates = @q.result.page(params[:page])
  end

  # GET /estimates/1
  def show
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new

    render :step_1
  end

  # GET /estimates/1/edit
  def edit
  end

  # POST /estimates
  def create
    @estimate = Estimate.new(estimate_params)

    if @estimate.save
      redirect_to @estimate, notice: 'Estimate foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /estimates/1
  def update
    if @estimate.update(estimate_params)
      redirect_to @estimate, notice: 'Estimate foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /estimates/1
  def destroy
    @estimate.destroy
    redirect_to estimates_url, notice: 'Estimate foi apagado com sucesso.'
  end

  def schedule
    render :schedule
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def estimate_params
      params.require(:estimate).permit(:code, :title, :worker_id, :status, :description, :location, :latitude, :longitude, :category, :order_id, :price, :tax, :tax_calculation, :lead_id, :bpmn_instance, :current, :total)
    end
end
