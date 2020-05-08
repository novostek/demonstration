require 'test_helper'

class DocumentPrototypeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get document_prototype_creat_url
    assert_response :success
  end

  test "should get deliver" do
    get document_prototype_deliver_url
    assert_response :success
  end

  test "should get sign" do
    get document_prototype_sign_url
    assert_response :success
  end

end
