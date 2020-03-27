class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only: [:new,:edit,:create,:update]

  # GET /products
  def index
    @q = Product.all.ransack(params[:q])
    @products = @q.result.page(params[:page])
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product foi apagado com sucesso.'
  end

  private

    #Método que carrega os objetos de seleção
    def set_combos
      @categories = ProductCategory.to_select
      @formulas = CalculationFormula.to_select
      @suppliers = Supplier.to_select
      @products = Product.to_select
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:photo,:calculation_formula_id,:supplier_id,:name, :uuid, :details, :product_category_id, :customer_price, :cost_price, :area_covered, :tax, :bpm_purchase)
    end
end
