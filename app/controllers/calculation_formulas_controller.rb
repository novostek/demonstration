class CalculationFormulasController < ApplicationController
  load_and_authorize_resource except: [:calculate_product_qty_lw]
  before_action :set_calculation_formula, only: [:show, :edit, :update, :destroy]

  # GET /calculation_formulas
  def index
    @q = CalculationFormula.all.ransack(params[:q])
    @calculation_formulas = @q.result.page(params[:page])
  end

  # GET /calculation_formulas/1
  def show
  end

  # GET /calculation_formulas/new
  def new
    @calculation_formula = CalculationFormula.new
  end

  # GET /calculation_formulas/1/edit
  def edit
  end

  # POST /calculation_formulas
  def create
    @calculation_formula = CalculationFormula.new(calculation_formula_params)

    if @calculation_formula.save
      redirect_to @calculation_formula, notice: t('notice.calculation_formula.created')
    else
      render :new
    end
  end

  # PATCH/PUT /calculation_formulas/1
  def update
    if @calculation_formula.update(calculation_formula_params)
      redirect_to @calculation_formula, notice: t('notice.calculation_formula.updated')
    else
      render :edit
    end
  end

  # DELETE /calculation_formulas/1
  def destroy
    @calculation_formula.destroy
    redirect_to calculation_formulas_url, notice: t('notice.calculation_formula.deleted')
  end

  def taxes
    @taxes = CalculationFormula.where(tax: true)
    render json: @taxes
  end

  def calculate_product_qty_lw
    calculator = Dentaku::Calculator.new
    area = Measurement.square_meter(params[:areas])
    width = Measurement.sum_column(params[:areas], :width)
    height = Measurement.sum_column(params[:areas], :height)
    lenght = Measurement.sum_column(params[:areas], :lenght)
    product = Product.find(params[:product_id])
    formula = product.calculation_formula
    qty = calculator.evaluate(
        formula.formula,
        area: area, area_covered: product.area_covered, width: width, height: height, lenght: lenght
    ).to_f
    render json: {
      id: product.id,
      name: product.name,
      qty: qty,
      tax: product.tax,
      total: product.customer_price * qty,
      price: product.customer_price
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calculation_formula
      @calculation_formula = CalculationFormula.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calculation_formula_params
      params.require(:calculation_formula).permit(:name, :formula, :description, :tax, :namespace, :default, :col_name)
    end
end
