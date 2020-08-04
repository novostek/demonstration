class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:confirm,:finish_confirm]

  # GET /clients
  def index
    @q = Client.all.ransack(params[:q])
    @clients = @q.result.page(params[:page])
  end

  def confirm
    @code = params[:code]
    render layout: "clean"
  end

  def finish_confirm
      @job = RunningJob.create(complete:false, redirect: "")
      ConfirmJob.perform_later(params[:code], @job)
      render layout: "loading"
  end

  # GET /clients/1
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: t('notice.client.created')
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      redirect_to @client, notice: t('notice.client.updated')
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url, notice: t('notice.client.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.require(:client).permit(:name, :tenant_name)
    end
end
