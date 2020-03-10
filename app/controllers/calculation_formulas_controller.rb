class CalculationFormulasController < ApplicationController
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
      redirect_to @calculation_formula, notice: 'Calculation was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /calculation_formulas/1
  def update
    if @calculation_formula.update(calculation_formula_params)
      redirect_to @calculation_formula, notice: 'Calculation formula was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /calculation_formulas/1
  def destroy
    @calculation_formula.destroy
    redirect_to calculation_formulas_url, notice: 'Calculation formula was successfully deleted.'
  end

  def calculate_product_qty_lw
    calculator = Dentaku::Calculator.new
    area = Measurement.square_meter(JSON.parse params[:areas_ids])
    product = Product.find(params[:product_id])
    formula = product.calculation_formula
    qty = calculator.evaluate(formula.formula, area: area, area_covered: product.area_covered).to_f
    render json: {
      qty: qty,
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
      params.require(:calculation_formula).permit(:name, :formula, :description, :tax, :namespace)
    end
end
