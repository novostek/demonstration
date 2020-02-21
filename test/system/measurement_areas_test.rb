require "application_system_test_case"

class MeasurementAreasTest < ApplicationSystemTestCase
  setup do
    @measurement_area = measurement_areas(:one)
  end

  test "visiting the index" do
    visit measurement_areas_url
    assert_selector "h1", text: "Measurement Areas"
  end

  test "creating a Measurement area" do
    visit measurement_areas_url
    click_on "New Measurement Area"

    fill_in "Description", with: @measurement_area.description
    fill_in "Estimate", with: @measurement_area.estimate_id
    fill_in "Name", with: @measurement_area.name
    click_on "Create Measurement area"

    assert_text "Measurement area was successfully created"
    click_on "Back"
  end

  test "updating a Measurement area" do
    visit measurement_areas_url
    click_on "Edit", match: :first

    fill_in "Description", with: @measurement_area.description
    fill_in "Estimate", with: @measurement_area.estimate_id
    fill_in "Name", with: @measurement_area.name
    click_on "Update Measurement area"

    assert_text "Measurement area was successfully updated"
    click_on "Back"
  end

  test "destroying a Measurement area" do
    visit measurement_areas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Measurement area was successfully destroyed"
  end
end
