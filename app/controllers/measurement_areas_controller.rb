class MeasurementAreasController < ApplicationController
  load_and_authorize_resource except: :measurements
  before_action :set_measurement_area, only: [:show, :edit, :update, :destroy]

  # GET /measurement_areas
  def index
    @q = MeasurementArea.all.ransack(params[:q])
    @measurement_areas = @q.result.page(params[:page])
  end

  # GET /measurement_areas/1
  def show
  end

  # GET /measurement_areas/new
  def new
    @measurement_area = MeasurementArea.new
  end

  # GET /measurement_areas/1/edit
  def edit
  end

  # POST /measurement_areas
  def create
    @measurement_area = MeasurementArea.new(measurement_area_params)

    if @measurement_area.save
      redirect_to @measurement_area, notice: 'Measurement area foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /measurement_areas/1
  def update
    if @measurement_area.update(measurement_area_params)
      redirect_to @measurement_area, notice: 'Measurement area foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /measurement_areas/1
  def destroy
    @measurement_area.destroy
    redirect_to measurement_areas_url, notice: 'Measurement area foi apagado com sucesso.'
  end

  def measurements
    @estimate = Estimate.find(params[:id])
    if @estimate.ordered?
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.already_ordered')
      return
    end
    @hidden_fields = Setting.get_value('hidden_measurement_fields')
    render :measurements_areas
  end

  def create_measurements
    measures = params
    1+1
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement_area
      @measurement_area = MeasurementArea.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def measurement_area_params
      params.require(:measurement_area).permit(:estimate_id, :name, :description, {photos: []}, measurements_attributes: [:id, :length, :width, :height, :_destroy])
    end
end
