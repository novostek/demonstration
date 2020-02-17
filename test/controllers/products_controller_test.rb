require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { area_covered: @product.area_covered, bpm_purchase: @product.bpm_purchase, cost_price: @product.cost_price, customer_price: @product.customer_price, details: @product.details, name: @product.name, product_category_id: @product.product_category_id, tax: @product.tax, uuid: @product.uuid } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { area_covered: @product.area_covered, bpm_purchase: @product.bpm_purchase, cost_price: @product.cost_price, customer_price: @product.customer_price, details: @product.details, name: @product.name, product_category_id: @product.product_category_id, tax: @product.tax, uuid: @product.uuid } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
