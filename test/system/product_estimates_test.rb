require "application_system_test_case"

class ProductEstimatesTest < ApplicationSystemTestCase
  setup do
    @product_estimate = product_estimates(:one)
  end

  test "visiting the index" do
    visit product_estimates_url
    assert_selector "h1", text: "Product Estimates"
  end

  test "creating a Product estimate" do
    visit product_estimates_url
    click_on "New Product Estimate"

    fill_in "Custom title", with: @product_estimate.custom_title
    fill_in "Discount", with: @product_estimate.discount
    fill_in "Measurement proposal", with: @product_estimate.measurement_proposal_id
    fill_in "Notes", with: @product_estimate.notes
    fill_in "Product", with: @product_estimate.product_id
    fill_in "Quantity", with: @product_estimate.quantity
    check "Tax" if @product_estimate.tax
    fill_in "Unitary value", with: @product_estimate.unitary_value
    fill_in "Value", with: @product_estimate.value
    click_on "Create Product estimate"

    assert_text "Product estimate was successfully created"
    click_on "Back"
  end

  test "updating a Product estimate" do
    visit product_estimates_url
    click_on "Edit", match: :first

    fill_in "Custom title", with: @product_estimate.custom_title
    fill_in "Discount", with: @product_estimate.discount
    fill_in "Measurement proposal", with: @product_estimate.measurement_proposal_id
    fill_in "Notes", with: @product_estimate.notes
    fill_in "Product", with: @product_estimate.product_id
    fill_in "Quantity", with: @product_estimate.quantity
    check "Tax" if @product_estimate.tax
    fill_in "Unitary value", with: @product_estimate.unitary_value
    fill_in "Value", with: @product_estimate.value
    click_on "Update Product estimate"

    assert_text "Product estimate was successfully updated"
    click_on "Back"
  end

  test "destroying a Product estimate" do
    visit product_estimates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product estimate was successfully destroyed"
  end
end
