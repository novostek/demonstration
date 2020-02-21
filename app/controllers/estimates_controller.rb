class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only: [:step_one]
  skip_forgery_protection
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

  def step_one
    last_estimate = Estimate.last
    @estimate = Estimate.new
    
    if last_estimate.present?
      @estimate.code = last_estimate[:code].to_i + 1
    else
      @estimate.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
    end
    @lead = Lead.find(params[:lead_id])
    render :step_1
  end

  def create_step_one
    estimate = Estimate.new
    estimate.code = params[:code]
    estimate.title = params[:title]
    estimate.description = params[:description]
    estimate.location = params[:location]
    estimate.latitude = params[:latitude]
    estimate.longitude = params[:longitude]
    estimate.sales_person_id = params[:sales_person_id]
    estimate.lead_id = params[:lead_id]
    estimate.status = 'new'
    estimate.total = 0.0
    estimate.category = 'test'

    if estimate.save
      redirect_to schedule_estimate_path(estimate.id)
    end
  end
  
  def schedule
    @estimate = Estimate.find(params[:id])
    @workers = Worker.all
    @schedules = @estimate.schedules
    render :schedule
  end

  def create_schedule
    estimate = Estimate.find(params[:estimate_id])

    schedule_obj = {
      :title => params[:title],
      :category => params[:category],
      :description => params[:description],
      :start_at => params[:start_at],
      :end_at => params[:end_at],
      :color => params[:color],
      :worker_id => params[:worker_id],
      :origin => "Estimate",
      :origin_id => estimate.id
    }

    schedule = Schedule.new_schedule(schedule_obj)

    render json: schedule
  end

  def delete_schedule
    schedule = Schedule.find_by(worke)
  end

  def measurements
    render :measurements
  end

  def products
    render :products
  end

  private
    #Método que carrega os objetos de seleção
    def set_combos
      @workers = Worker.to_select
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def estimate_params
      params.require(:estimate).permit(:code, :title, :worker_id, :status, :description, :location, :latitude, :longitude, :category, :order_id, :price, :tax, :tax_calculation, :lead_id, :bpmn_instance, :current, :total)
    end
end
