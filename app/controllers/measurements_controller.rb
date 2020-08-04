class MeasurementsController < ApplicationController
  load_and_authorize_resource
  before_action :set_measurement, only: [:show, :edit, :update, :destroy]

  # GET /measurements
  def index
    @q = Measurement.all.ransack(params[:q])
    @measurements = @q.result.page(params[:page])
  end

  # GET /measurements/1
  def show
  end

  # GET /measurements/new
  def new
    @measurement = Measurement.new
  end

  # GET /measurements/1/edit
  def edit
  end

  # POST /measurements
  def create
    @measurement = Measurement.new(measurement_params)

    if @measurement.save
      redirect_to @measurement, notice: t('notice.measurement.created')
    else
      render :new
    end
  end

  # PATCH/PUT /measurements/1
  def update
    if @measurement.update(measurement_params)
      redirect_to @measurement, notice: t('notice.measurement.updated')
    else
      render :edit
    end
  end

  # DELETE /measurements/1
  def destroy
    @measurement.destroy
    redirect_to measurements_url, notice: t('notice.measurement.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def measurement_params
      params.require(:measurement).permit(:measurement_area_id, :width, :height, :length)
    end
end
