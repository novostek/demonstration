require 'test_helper'

class EstimatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @estimate = estimates(:one)
  end

  test "should get index" do
    get estimates_url
    assert_response :success
  end

  test "should get new" do
    get new_estimate_url
    assert_response :success
  end

  test "should create estimate" do
    assert_difference('Estimate.count') do
      post estimates_url, params: { estimate: { bpmn_instance: @estimate.bpmn_instance, category: @estimate.category, code: @estimate.code, current: @estimate.current, description: @estimate.description, latitude: @estimate.latitude, lead_id: @estimate.lead_id, location: @estimate.location, longitude: @estimate.longitude, order_id: @estimate.order_id, price: @estimate.price, status: @estimate.status, tax: @estimate.tax, tax_calculation: @estimate.tax_calculation, title: @estimate.title, total: @estimate.total, worker_id: @estimate.worker_id } }
    end

    assert_redirected_to estimate_url(Estimate.last)
  end

  test "should show estimate" do
    get estimate_url(@estimate)
    assert_response :success
  end

  test "should get edit" do
    get edit_estimate_url(@estimate)
    assert_response :success
  end

  test "should update estimate" do
    patch estimate_url(@estimate), params: { estimate: { bpmn_instance: @estimate.bpmn_instance, category: @estimate.category, code: @estimate.code, current: @estimate.current, description: @estimate.description, latitude: @estimate.latitude, lead_id: @estimate.lead_id, location: @estimate.location, longitude: @estimate.longitude, order_id: @estimate.order_id, price: @estimate.price, status: @estimate.status, tax: @estimate.tax, tax_calculation: @estimate.tax_calculation, title: @estimate.title, total: @estimate.total, worker_id: @estimate.worker_id } }
    assert_redirected_to estimate_url(@estimate)
  end

  test "should destroy estimate" do
    assert_difference('Estimate.count', -1) do
      delete estimate_url(@estimate)
    end

    assert_redirected_to estimates_url
  end
end
