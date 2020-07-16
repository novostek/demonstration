class LeadsController < ApplicationController
  load_and_authorize_resource
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  def index
    @q = Lead.all.order(created_at: :desc).ransack(params[:q])
    @leads = @q.result.page(params[:page])
      #add_breadcrumb I18n.t('activerecord.models.leads'), leads_path
  end

  # GET /leads/1
  def show
    #add_breadcrumb I18n.t('breadcrumbs.view'), lead_path(@lead)
  end

  # GET /leads/new
  def new
    @lead = Lead.new
    @lead.date = Time.now
    @customer = Customer.new
    @edit = false
    #add_breadcrumb I18n.t('breadcrumbs.new'), new_lead_path
    return [@lead, @customer]
  end

  # GET /leads/1/edit
  def edit
    @edit = true
    # @lead.date = @lead.date.strftime("%m/%d/%Y %H:%M")
    @customer = Customer.new
      #add_breadcrumb I18n.t('breadcrumbs.edit'), edit_lead_path(@lead)
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)
    if @lead.customer.blank?
      @lead.customer = Customer.search_by_phone(params[:phone]).first
    end
    if @lead.save
      if params[:button] == "save_n_estimate"
        @lead.status = 'closed'
        @lead.save
        redirect_to step_one_estimates_path(@lead.id)
      else
        redirect_to @lead, notice: t('notice.lead.created')
      end
    else
      @customer = Customer.new
      render :new
    end
  end

  # PATCH/PUT /leads/1
  def update
    # params[:lead][:date] = DateTime.strptime(params[:lead][:date], "%m/%d/%Y %H:%M")
    if @lead.update(lead_params)
      redirect_to @lead, notice: t('notice.lead.updated')
    else
      render :edit
    end
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy
    redirect_to leads_url, notice: t('notice.lead.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lead_params
      params.require(:lead).permit(:customer_id, :via, :description, :status, :date, :phone, :email, :code)
    end
end
