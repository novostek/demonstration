require "application_system_test_case"

class ProductPurchasesTest < ApplicationSystemTestCase
  setup do
    @product_purchase = product_purchases(:one)
  end

  test "visiting the index" do
    visit product_purchases_url
    assert_selector "h1", text: "Product Purchases"
  end

  test "creating a Product purchase" do
    visit product_purchases_url
    click_on "New Product Purchase"

    fill_in "Custom title", with: @product_purchase.custom_title
    fill_in "Product", with: @product_purchase.product_id
    fill_in "Purchase", with: @product_purchase.purchase_id
    fill_in "Quantity", with: @product_purchase.quantity
    fill_in "Status", with: @product_purchase.status
    fill_in "Unity value", with: @product_purchase.unity_value
    fill_in "Value", with: @product_purchase.value
    click_on "Create Product purchase"

    assert_text "Product purchase was successfully created"
    click_on "Back"
  end

  test "updating a Product purchase" do
    visit product_purchases_url
    click_on "Edit", match: :first

    fill_in "Custom title", with: @product_purchase.custom_title
    fill_in "Product", with: @product_purchase.product_id
    fill_in "Purchase", with: @product_purchase.purchase_id
    fill_in "Quantity", with: @product_purchase.quantity
    fill_in "Status", with: @product_purchase.status
    fill_in "Unity value", with: @product_purchase.unity_value
    fill_in "Value", with: @product_purchase.value
    click_on "Update Product purchase"

    assert_text "Product purchase was successfully updated"
    click_on "Back"
  end

  test "destroying a Product purchase" do
    visit product_purchases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product purchase was successfully destroyed"
  end
end
