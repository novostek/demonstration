require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get woffice_pay_code" do
    get api_woffice_pay_code_url
    assert_response :success
  end

  test "should get order_paid" do
    get api_order_paid_url
    assert_response :success
  end

end
