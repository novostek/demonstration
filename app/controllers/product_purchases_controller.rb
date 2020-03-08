class ProductPurchasesController < ApplicationController
  before_action :set_product_purchase, only: [:show, :edit, :update, :destroy]

  # GET /product_purchases
  def index
    @q = ProductPurchase.all.ransack(params[:q])
    @product_purchases = @q.result.page(params[:page])
  end

  # GET /product_purchases/1
  def show
  end

  # GET /product_purchases/new
  def new
    @product_purchase = ProductPurchase.new
  end

  # GET /product_purchases/1/edit
  def edit
  end

  # POST /product_purchases
  def create
    @product_purchase = ProductPurchase.new(product_purchase_params)

    if @product_purchase.save
      redirect_to @product_purchase, notice: 'Product purchase foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /product_purchases/1
  def update
    if @product_purchase.update(product_purchase_params)
      redirect_to @product_purchase, notice: 'Product purchase foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /product_purchases/1
  def destroy
    @product_purchase.destroy
    redirect_to product_purchases_url, notice: 'Product purchase foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_purchase
      @product_purchase = ProductPurchase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_purchase_params
      params.require(:product_purchase).permit(:product_id, :purchase_id, :unity_value, :quantity, :value, :status, :custom_title)
    end
end
