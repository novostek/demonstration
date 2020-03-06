class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only: [:step_one]
  # skip_forgery_protection
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
      redirect_to products_estimate_path(@estimate.id), notice: 'Estimate foi atualizado com sucesso.'
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
    @estimate = Estimate.find_or_initialize_by(lead_id: params[:lead_id])
    
    @lead = Lead.find(params[:lead_id])
    render :step_1
  end

  def create_step_one
    estimate = Estimate.find_or_initialize_by(lead_id: params[:lead_id])
    estimate.code = params[:estimate][:code]
    estimate.title = params[:estimate][:title]
    estimate.description = params[:estimate][:description]
    estimate.location = params[:estimate][:location]
    estimate.latitude = params[:estimate][:latitude]
    estimate.longitude = params[:estimate][:longitude]
    estimate.sales_person_id = params[:estimate][:sales_person_id]
    estimate.lead_id = params[:lead_id]
    estimate.status = 'new'
    estimate.total = 0.0
    estimate.category = 'test'

    if estimate.save()
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
      :schedule_id => params[:schedule_id],
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
    schedule = Schedule.find_by(origin: params[:origin], origin_id: params[:estimate_id], worker_id: params[:worker_id])

    schedule.destroy
  end
  
  def products
    estimate = Estimate.includes(:lead).find(params[:id])
    # @measurement_areas = @estimate.measurement_areas.build
    # @measurement_areas.measurement_proposals.build
    # @estimate = @estimate.in

    @estimate = {
      :estimate => {
        :data => estimate,
        :lead => {
          :data => estimate.lead,
          :customer => {
            :data => estimate.lead.customer
          }
        },
        :measurement_areas => {
          :data => estimate.measurement_areas
        }
      }
    }

    @products = Product.all.select(:id, :name)

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
      params.require(:estimate).permit(
          :code, :title, :worker_id, :status, :description, :location, 
          :latitude, :longitude, :category, :order_id, :price, :tax, 
          :tax_calculation, :lead_id, :bpmn_instance, :current, :total,
          measurement_areas_attributes: [
            :id, :estimate_id, :name, :description, :_destroy,
            measurements_attributes: [
              :id, :length, :width, :height, :_destroy
            ]
          ])
    end
end
