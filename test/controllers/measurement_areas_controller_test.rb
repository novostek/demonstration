require 'test_helper'

class MeasurementAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @measurement_area = measurement_areas(:one)
  end

  test "should get index" do
    get measurement_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_measurement_area_url
    assert_response :success
  end

  test "should create measurement_area" do
    assert_difference('MeasurementArea.count') do
      post measurement_areas_url, params: { measurement_area: { description: @measurement_area.description, estimate_id: @measurement_area.estimate_id, name: @measurement_area.name } }
    end

    assert_redirected_to measurement_area_url(MeasurementArea.last)
  end

  test "should show measurement_area" do
    get measurement_area_url(@measurement_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_measurement_area_url(@measurement_area)
    assert_response :success
  end

  test "should update measurement_area" do
    patch measurement_area_url(@measurement_area), params: { measurement_area: { description: @measurement_area.description, estimate_id: @measurement_area.estimate_id, name: @measurement_area.name } }
    assert_redirected_to measurement_area_url(@measurement_area)
  end

  test "should destroy measurement_area" do
    assert_difference('MeasurementArea.count', -1) do
      delete measurement_area_url(@measurement_area)
    end

    assert_redirected_to measurement_areas_url
  end
end
