require "application_system_test_case"

class CalculationFormulasTest < ApplicationSystemTestCase
  setup do
    @calculation_formula = calculation_formulas(:one)
  end

  test "visiting the index" do
    visit calculation_formulas_url
    assert_selector "h1", text: "Calculation Formulas"
  end

  test "creating a Calculation formula" do
    visit calculation_formulas_url
    click_on "New Calculation Formula"

    fill_in "Description", with: @calculation_formula.description
    fill_in "Formula", with: @calculation_formula.formula
    fill_in "Name", with: @calculation_formula.name
    fill_in "Namespace", with: @calculation_formula.namespace
    check "Taz" if @calculation_formula.taz
    click_on "Create Calculation formula"

    assert_text "Calculation formula was successfully created"
    click_on "Back"
  end

  test "updating a Calculation formula" do
    visit calculation_formulas_url
    click_on "Edit", match: :first

    fill_in "Description", with: @calculation_formula.description
    fill_in "Formula", with: @calculation_formula.formula
    fill_in "Name", with: @calculation_formula.name
    fill_in "Namespace", with: @calculation_formula.namespace
    check "Taz" if @calculation_formula.taz
    click_on "Update Calculation formula"

    assert_text "Calculation formula was successfully updated"
    click_on "Back"
  end

  test "destroying a Calculation formula" do
    visit calculation_formulas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Calculation formula was successfully destroyed"
  end
end
