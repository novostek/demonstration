require 'test_helper'

class CalculationFormulasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calculation_formula = calculation_formulas(:one)
  end

  test "should get index" do
    get calculation_formulas_url
    assert_response :success
  end

  test "should get new" do
    get new_calculation_formula_url
    assert_response :success
  end

  test "should create calculation_formula" do
    assert_difference('CalculationFormula.count') do
      post calculation_formulas_url, params: { calculation_formula: { description: @calculation_formula.description, formula: @calculation_formula.formula, name: @calculation_formula.name, namespace: @calculation_formula.namespace, taz: @calculation_formula.taz } }
    end

    assert_redirected_to calculation_formula_url(CalculationFormula.last)
  end

  test "should show calculation_formula" do
    get calculation_formula_url(@calculation_formula)
    assert_response :success
  end

  test "should get edit" do
    get edit_calculation_formula_url(@calculation_formula)
    assert_response :success
  end

  test "should update calculation_formula" do
    patch calculation_formula_url(@calculation_formula), params: { calculation_formula: { description: @calculation_formula.description, formula: @calculation_formula.formula, name: @calculation_formula.name, namespace: @calculation_formula.namespace, taz: @calculation_formula.taz } }
    assert_redirected_to calculation_formula_url(@calculation_formula)
  end

  test "should destroy calculation_formula" do
    assert_difference('CalculationFormula.count', -1) do
      delete calculation_formula_url(@calculation_formula)
    end

    assert_redirected_to calculation_formulas_url
  end
end
