class LeadsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  def index
    @q = Lead.all.ransack(params[:q])
    @leads = @q.result.page(params[:page])
  end

  # GET /leads/1
  def show
  end

  # GET /leads/new
  def new
    @lead = Lead.new
    @customer = Customer.new

    return [@lead, @customer]
  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      if params[:button] == "save_n_estimate"
        @lead.status = 'closed'
        @lead.save
        redirect_to step_one_estimates_path(@lead.id)
      else
        redirect_to @lead, notice: 'Lead was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /leads/1
  def update
    if @lead.update(lead_params)
      redirect_to @lead, notice: 'Lead was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy
    redirect_to leads_url, notice: 'Lead was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lead_params
      params.require(:lead).permit(:customer_id, :via, :description, :status, :date, :phone)
    end
end
