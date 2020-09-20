class RunningJobsController < ApplicationController
  before_action :set_running_job, only: [:show, :edit, :update, :destroy,:is_complete]
  before_action :authenticate_user!, except: [:is_complete]

  # GET /running_jobs
  def index
    @q = RunningJob.all.ransack(params[:q])
    @running_jobs = @q.result.page(params[:page])
  end

  # GET /running_jobs/1
  def show
  end

  #método que checa se o job finalizou
  def is_complete
    render json: @running_job
  end

  # GET /running_jobs/new
  def new
    @running_job = RunningJob.new
  end

  # GET /running_jobs/1/edit
  def edit
  end

  # POST /running_jobs
  def create
    @running_job = RunningJob.new(running_job_params)

    if @running_job.save
      redirect_to @running_job, notice: t('notice.running_job.created')
    else
      render :new
    end
  end

  # PATCH/PUT /running_jobs/1
  def update
    if @running_job.update(running_job_params)
      redirect_to @running_job, notice: t('notice.running_job.updated')
    else
      render :edit
    end
  end

  # DELETE /running_jobs/1
  def destroy
    @running_job.destroy
    redirect_to running_jobs_url, notice: t('notice.running_job.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_running_job
      @running_job = RunningJob.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def running_job_params
      params.require(:running_job).permit(:complete, :redirect)
    end
end
