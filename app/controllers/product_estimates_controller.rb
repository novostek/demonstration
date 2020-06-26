class ProductEstimatesController < ApplicationController
  before_action :set_product_estimate, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:destroy]
  load_and_authorize_resource except: [:destroy]

  # GET /product_estimates
  def index
    @q = ProductEstimate.all.ransack(params[:q])
    @product_estimates = @q.result.page(params[:page])
  end

  # GET /product_estimates/1
  def show
  end

  # GET /product_estimates/new
  def new
    @product_estimate = ProductEstimate.new
  end

  # GET /product_estimates/1/edit
  def edit
  end

  # POST /product_estimates
  def create
    @product_estimate = ProductEstimate.new(product_estimate_params)

    if @product_estimate.save
      redirect_to @product_estimate, notice: t('notice.product_estimate.created')
    else
      render :new
    end
  end

  # PATCH/PUT /product_estimates/1
  def update
    if @product_estimate.update(product_estimate_params)
      redirect_to @product_estimate, notice: t('notice.product_estimate.updated')
    else
      render :edit
    end
  end

  # DELETE /product_estimates/1
  def destroy
    @product_estimate.destroy
    render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_estimate
      @product_estimate = ProductEstimate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_estimate_params
      params.require(:product_estimate).permit(:product_id, :custom_title, :notes, :unitary_value, :quantity, :discount, :value, :tax, :measurement_proposal_id)
    end
end
