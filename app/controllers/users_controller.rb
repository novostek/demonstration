class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only: [:new, :edit, :update, :create]

  # GET /users
  def index
    @q = User.all.ransack(params[:q])
    @users = @q.result.page(params[:page])
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new(active: true)
  end

  # GET /users/1/edit
  def edit
  end

  def home
    if current_user.profiles.where(name: "Worker").present? and current_user.worker.present?
      render "workers/dashboard"
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User foi apagado com sucesso.'
  end

  private
  #Método que carrega os objetos para serem utilizados no form
  def set_combos
    @profiles = Profile.to_select
    @workers = Worker.to_select
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:password,:password_confirmation, :worker_id,:active, profile_ids:[])
    end
end
