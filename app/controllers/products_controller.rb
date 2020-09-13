class ProductsController < ApplicationController
  load_and_authorize_resource except: [:quick_estimate]
  before_action :set_product, only: [:show, :edit, :update, :destroy, :sticker, :quick_estimate]
  before_action :set_combos, only: [:new,:edit,:create,:update]
  before_action :init_entity_modal, only: [:new,:edit,:create,:update]
  skip_before_action :authenticate_user!, only: [:show, :quick_estimate]

  # GET /products
  def index
    if params[:format] == "json"
      limit = 5000
    else
      limit = 50
    end
    @q = Product.all.order(name: :asc).where(active: true).ransack(params[:q])
    @products = @q.result.page(params[:page]).per(limit)
  end

  # GET /products/1
  def show
    if !user_signed_in?
      render layout: 'clean'
    end
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.calculation_formula = CalculationFormula.find_by_namespace('default-formula')
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new
    @product.photo_cache = product_params[:photo_cache]
    @product.calculation_formula_id = product_params[:calculation_formula_id]
    @product.supplier_id = product_params[:supplier_id]
    @product.name = product_params[:name]
    @product.uuid = product_params[:uuid]
    @product.details = product_params[:details]
    @product.product_category_id = product_params[:product_category_id]
    @product.customer_price = product_params[:customer_price]
    @product.cost_price = product_params[:cost_price]
    @product.area_covered = product_params[:area_covered]
    @product.tax = product_params[:tax]
    @product.bpm_purchase = product_params[:bpm_purchase]
    @product.photo = product_params[:photo]

    if @product.save
      if product_params[:suggestion_ids].present?
        product_params[:suggestion_ids].each_with_index do |s, index|
          product_params[:suggestion_ids][index] = Product.find(s)
        end
      end
      if @product.update(product_params)
        if params[:remote].nil?
          redirect_to @product, notice: t('notice.product.created')
        end
      else
        render :new
      end
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if product_params[:suggestion_ids].present?
      product_params[:suggestion_ids].each_with_index do |s, index|
        product_params[:suggestion_ids][index] = Product.find(s)
      end
    end
    if @product.update(product_params)
      redirect_to @product, notice: t('notice.product.updated')
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: t('notice.product.deleted')
  end

  def new_delivery
    @schedule = Product.create(product_params)
    # redirect_back(fallback_location: order_path(params[:order_id]))
  end

  def sticker
    qrcode = RQRCode::QRCode.new("#{Setting.url}/products/#{params[:id]}")
    @png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: 'black',
        file: nil,
        fill: 'white',
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 350
    )
    respond_to do |format|
      format.html {render layout: 'clean'}
      format.png {   send_data @png.to_s , filename: "qrcode.png", type: "image/png", disposition: 'inline', stream: 'true', buffer_size: '4096' }
    end
  end

  def quick_estimate
    calculator = Dentaku::Calculator.new
    qty = calculator.evaluate(
    @product.calculation_formula.formula,
        area: params[:area].to_f, area_covered: @product.area_covered, width: params[:width].to_f, height: params[:height].to_f, lenght: params[:lenght].to_f
    ).to_f
    render json: {quantity: qty}
  end

  private
    def init_entity_modal
      @supplier = Supplier.new
      @category = ProductCategory.new
    end

    #Método que carrega os objetos de seleção
    def set_combos
      @categories = ProductCategory.to_select
      @formulas = CalculationFormula.where(tax:[false, nil]).to_select
      @suppliers = Supplier.to_select
      @products = Product.to_select
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(
        :photo,:photo_cache,:calculation_formula_id,:supplier_id,:name, :uuid, :active,
        :details, :product_category_id, :customer_price, :cost_price, 
        :area_covered, :tax, :bpm_purchase, suggestion_ids: [],
        :product_schedules_attributes => [:product_ids, :schedules, :_destroy])
    end
end
