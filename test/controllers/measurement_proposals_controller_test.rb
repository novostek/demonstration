require 'test_helper'

class MeasurementProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @measurement_proposal = measurement_proposals(:one)
  end

  test "should get index" do
    get measurement_proposals_url
    assert_response :success
  end

  test "should get new" do
    get new_measurement_proposal_url
    assert_response :success
  end

  test "should create measurement_proposal" do
    assert_difference('MeasurementProposal.count') do
      post measurement_proposals_url, params: { measurement_proposal: { notes: @measurement_proposal.notes } }
    end

    assert_redirected_to measurement_proposal_url(MeasurementProposal.last)
  end

  test "should show measurement_proposal" do
    get measurement_proposal_url(@measurement_proposal)
    assert_response :success
  end

  test "should get edit" do
    get edit_measurement_proposal_url(@measurement_proposal)
    assert_response :success
  end

  test "should update measurement_proposal" do
    patch measurement_proposal_url(@measurement_proposal), params: { measurement_proposal: { notes: @measurement_proposal.notes } }
    assert_redirected_to measurement_proposal_url(@measurement_proposal)
  end

  test "should destroy measurement_proposal" do
    assert_difference('MeasurementProposal.count', -1) do
      delete measurement_proposal_url(@measurement_proposal)
    end

    assert_redirected_to measurement_proposals_url
  end
end
