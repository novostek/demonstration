require 'test_helper'

class LaborCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @labor_cost = labor_costs(:one)
  end

  test "should get index" do
    get labor_costs_url
    assert_response :success
  end

  test "should get new" do
    get new_labor_cost_url
    assert_response :success
  end

  test "should create labor_cost" do
    assert_difference('LaborCost.count') do
      post labor_costs_url, params: { labor_cost: { date: @labor_cost.date, schedule_id: @labor_cost.schedule_id, status: @labor_cost.status, value: @labor_cost.value, worker_id: @labor_cost.worker_id } }
    end

    assert_redirected_to labor_cost_url(LaborCost.last)
  end

  test "should show labor_cost" do
    get labor_cost_url(@labor_cost)
    assert_response :success
  end

  test "should get edit" do
    get edit_labor_cost_url(@labor_cost)
    assert_response :success
  end

  test "should update labor_cost" do
    patch labor_cost_url(@labor_cost), params: { labor_cost: { date: @labor_cost.date, schedule_id: @labor_cost.schedule_id, status: @labor_cost.status, value: @labor_cost.value, worker_id: @labor_cost.worker_id } }
    assert_redirected_to labor_cost_url(@labor_cost)
  end

  test "should destroy labor_cost" do
    assert_difference('LaborCost.count', -1) do
      delete labor_cost_url(@labor_cost)
    end

    assert_redirected_to labor_costs_url
  end
end
