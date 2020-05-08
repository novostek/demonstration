require 'test_helper'

class ProductEstimatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_estimate = product_estimates(:one)
  end

  test "should get index" do
    get product_estimates_url
    assert_response :success
  end

  test "should get new" do
    get new_product_estimate_url
    assert_response :success
  end

  test "should create product_estimate" do
    assert_difference('ProductEstimate.count') do
      post product_estimates_url, params: { product_estimate: { custom_title: @product_estimate.custom_title, discount: @product_estimate.discount, measurement_proposal_id: @product_estimate.measurement_proposal_id, notes: @product_estimate.notes, product_id: @product_estimate.product_id, quantity: @product_estimate.quantity, tax: @product_estimate.tax, unitary_value: @product_estimate.unitary_value, value: @product_estimate.value } }
    end

    assert_redirected_to product_estimate_url(ProductEstimate.last)
  end

  test "should show product_estimate" do
    get product_estimate_url(@product_estimate)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_estimate_url(@product_estimate)
    assert_response :success
  end

  test "should update product_estimate" do
    patch product_estimate_url(@product_estimate), params: { product_estimate: { custom_title: @product_estimate.custom_title, discount: @product_estimate.discount, measurement_proposal_id: @product_estimate.measurement_proposal_id, notes: @product_estimate.notes, product_id: @product_estimate.product_id, quantity: @product_estimate.quantity, tax: @product_estimate.tax, unitary_value: @product_estimate.unitary_value, value: @product_estimate.value } }
    assert_redirected_to product_estimate_url(@product_estimate)
  end

  test "should destroy product_estimate" do
    assert_difference('ProductEstimate.count', -1) do
      delete product_estimate_url(@product_estimate)
    end

    assert_redirected_to product_estimates_url
  end
end
