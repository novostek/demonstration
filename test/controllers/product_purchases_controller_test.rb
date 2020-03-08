require 'test_helper'

class ProductPurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_purchase = product_purchases(:one)
  end

  test "should get index" do
    get product_purchases_url
    assert_response :success
  end

  test "should get new" do
    get new_product_purchase_url
    assert_response :success
  end

  test "should create product_purchase" do
    assert_difference('ProductPurchase.count') do
      post product_purchases_url, params: { product_purchase: { custom_title: @product_purchase.custom_title, product_id: @product_purchase.product_id, purchase_id: @product_purchase.purchase_id, quantity: @product_purchase.quantity, status: @product_purchase.status, unity_value: @product_purchase.unity_value, value: @product_purchase.value } }
    end

    assert_redirected_to product_purchase_url(ProductPurchase.last)
  end

  test "should show product_purchase" do
    get product_purchase_url(@product_purchase)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_purchase_url(@product_purchase)
    assert_response :success
  end

  test "should update product_purchase" do
    patch product_purchase_url(@product_purchase), params: { product_purchase: { custom_title: @product_purchase.custom_title, product_id: @product_purchase.product_id, purchase_id: @product_purchase.purchase_id, quantity: @product_purchase.quantity, status: @product_purchase.status, unity_value: @product_purchase.unity_value, value: @product_purchase.value } }
    assert_redirected_to product_purchase_url(@product_purchase)
  end

  test "should destroy product_purchase" do
    assert_difference('ProductPurchase.count', -1) do
      delete product_purchase_url(@product_purchase)
    end

    assert_redirected_to product_purchases_url
  end
end
