require "application_system_test_case"

class MeasurementProposalsTest < ApplicationSystemTestCase
  setup do
    @measurement_proposal = measurement_proposals(:one)
  end

  test "visiting the index" do
    visit measurement_proposals_url
    assert_selector "h1", text: "Measurement Proposals"
  end

  test "creating a Measurement proposal" do
    visit measurement_proposals_url
    click_on "New Measurement Proposal"

    fill_in "Notes", with: @measurement_proposal.notes
    click_on "Create Measurement proposal"

    assert_text "Measurement proposal was successfully created"
    click_on "Back"
  end

  test "updating a Measurement proposal" do
    visit measurement_proposals_url
    click_on "Edit", match: :first

    fill_in "Notes", with: @measurement_proposal.notes
    click_on "Update Measurement proposal"

    assert_text "Measurement proposal was successfully updated"
    click_on "Back"
  end

  test "destroying a Measurement proposal" do
    visit measurement_proposals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Measurement proposal was successfully destroyed"
  end
end
