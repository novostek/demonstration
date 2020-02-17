require 'test_helper'

class BpmnEditorControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get bpmn_editor_list_url
    assert_response :success
  end

  test "should get editor" do
    get bpmn_editor_editor_url
    assert_response :success
  end

  test "should get deploy" do
    get bpmn_editor_deploy_url
    assert_response :success
  end

end
