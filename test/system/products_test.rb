require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Area covered", with: @product.area_covered
    fill_in "Bpm purchase", with: @product.bpm_purchase
    fill_in "Cost price", with: @product.cost_price
    fill_in "Customer price", with: @product.customer_price
    fill_in "Details", with: @product.details
    fill_in "Name", with: @product.name
    fill_in "Product category", with: @product.product_category_id
    check "Tax" if @product.tax
    fill_in "Uuid", with: @product.uuid
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Area covered", with: @product.area_covered
    fill_in "Bpm purchase", with: @product.bpm_purchase
    fill_in "Cost price", with: @product.cost_price
    fill_in "Customer price", with: @product.customer_price
    fill_in "Details", with: @product.details
    fill_in "Name", with: @product.name
    fill_in "Product category", with: @product.product_category_id
    check "Tax" if @product.tax
    fill_in "Uuid", with: @product.uuid
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
