class ProfilesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only:[:new,:edit,:update,:create]



  # GET /profiles
  def index
    @q = Profile.all.ransack(params[:q])
    @profiles = @q.result.page(params[:page])
  end

  # GET /profiles/1
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    @profile.permissions = params[:permissoes]
    if @profile.save
      redirect_to @profile, notice: t('notice.profile.created')
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update

    @profile.name = params[:profile][:name]
    @profile.description = params[:profile][:description]
    @profile.permissions = params[:permissoes]
    if @profile.save
      redirect_to @profile, notice: t('notice.profile.updated')
    else
      render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: t('notice.profile.deleted')
  end

  private

    #Método que carrega todos os controllers da aplicaçAo
    def set_combos
      #Rails.application.eager_load! #rails 5
      #Zeitwerk::Loader.eager_load_all #rails 6
      #@controllers = ApplicationController.subclasses.map{|a| {controller: a, metodos: a.action_methods} if !["DeviseController"].include? a.to_s  }
      # ApplicationController.subclasses.map{|a| {controller: a, metodos: a.action_methods}}
      contrl = [
                BotController,
                CalculationFormulasController,
                ContactsController,
                CustomersController,
                DocumentFilesController,

                DocumentsController,
                EstimatesController,
                FinancesController,
                LaborCostsController,
                LeadsController,
                MeasurementAreasController,
                MeasurementProposalsController,
                MeasurementsController,
                MenusController,
                NotesController,
                OrdersController,
                ProductCategoriesController,
                ProductEstimatesController,
                ProductPurchasesController,
                ProductsController,
                ProfilesController,
                PurchasesController,
                SchedulesController,
                SettingsController,
                SignaturesController,
                SquareApiController,
                SuppliersController,
                TransactionAccountsController,
                TransactionCategoriesController, TransactionsController,
                UsersController,
                WorkersController]

      @controllers = contrl.map{|a| {controller: a, metodos: a.action_methods} }

    end


  # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:name, :description, :permissions, :status)
    end
end
