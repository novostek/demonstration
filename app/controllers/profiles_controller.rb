class ProfilesController < ApplicationController
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
      redirect_to @profile, notice: 'Profile foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update
    @profile.name = params[:profile][:nome]
    @profile.description = params[:profile][:descricao]
    @profile.permissions = params[:permissoes]
    if @profile.save
      redirect_to @profile, notice: 'Profile foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: 'Profile foi apagado com sucesso.'
  end

  private

    #Método que carrega todos os controllers da aplicaçAo
    def set_combos
      #Rails.application.eager_load! #rails 5
      Zeitwerk::Loader.eager_load_all #rails 6
      @controllers = ApplicationController.subclasses.map{|a| {controller: a, metodos: a.action_methods}}
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
