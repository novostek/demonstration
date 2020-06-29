class MeasurementProposalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_measurement_proposal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:destroy]
  # GET /measurement_proposals
  def index
    @q = MeasurementProposal.all.ransack(params[:q])
    @measurement_proposals = @q.result.page(params[:page])
  end

  # GET /measurement_proposals/1
  def show
  end

  # GET /measurement_proposals/new
  def new
    @measurement_proposal = MeasurementProposal.new
  end

  # GET /measurement_proposals/1/edit
  def edit
  end

  # POST /measurement_proposals
  def create
    @measurement_proposal = MeasurementProposal.new(measurement_proposal_params)

    if @measurement_proposal.save
      redirect_to @measurement_proposal, notice: 'Measurement was successfully created'
    else
      render :new
    end
  end

  # PATCH/PUT /measurement_proposals/1
  def update
    if @measurement_proposal.update(measurement_proposal_params)
      redirect_to @measurement_proposal, notice: 'Measurement proposal foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /measurement_proposals/1
  def destroy
    @measurement_proposal.destroy
    render json: { status: :ok }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement_proposal
      @measurement_proposal = MeasurementProposal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def measurement_proposal_params
      params.require(:measurement_proposal).permit(:notes)
    end
end
