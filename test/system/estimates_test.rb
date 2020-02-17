require "application_system_test_case"

class EstimatesTest < ApplicationSystemTestCase
  setup do
    @estimate = estimates(:one)
  end

  test "visiting the index" do
    visit estimates_url
    assert_selector "h1", text: "Estimates"
  end

  test "creating a Estimate" do
    visit estimates_url
    click_on "New Estimate"

    fill_in "Bpmn instance", with: @estimate.bpmn_instance
    fill_in "Category", with: @estimate.category
    fill_in "Code", with: @estimate.code
    check "Current" if @estimate.current
    fill_in "Description", with: @estimate.description
    fill_in "Latitude", with: @estimate.latitude
    fill_in "Lead", with: @estimate.lead_id
    fill_in "Location", with: @estimate.location
    fill_in "Longitude", with: @estimate.longitude
    fill_in "Order", with: @estimate.order_id
    fill_in "Price", with: @estimate.price
    fill_in "Status", with: @estimate.status
    fill_in "Tax", with: @estimate.tax
    fill_in "Tax calculation", with: @estimate.tax_calculation
    fill_in "Title", with: @estimate.title
    fill_in "Total", with: @estimate.total
    fill_in "Worker", with: @estimate.worker_id
    click_on "Create Estimate"

    assert_text "Estimate was successfully created"
    click_on "Back"
  end

  test "updating a Estimate" do
    visit estimates_url
    click_on "Edit", match: :first

    fill_in "Bpmn instance", with: @estimate.bpmn_instance
    fill_in "Category", with: @estimate.category
    fill_in "Code", with: @estimate.code
    check "Current" if @estimate.current
    fill_in "Description", with: @estimate.description
    fill_in "Latitude", with: @estimate.latitude
    fill_in "Lead", with: @estimate.lead_id
    fill_in "Location", with: @estimate.location
    fill_in "Longitude", with: @estimate.longitude
    fill_in "Order", with: @estimate.order_id
    fill_in "Price", with: @estimate.price
    fill_in "Status", with: @estimate.status
    fill_in "Tax", with: @estimate.tax
    fill_in "Tax calculation", with: @estimate.tax_calculation
    fill_in "Title", with: @estimate.title
    fill_in "Total", with: @estimate.total
    fill_in "Worker", with: @estimate.worker_id
    click_on "Update Estimate"

    assert_text "Estimate was successfully updated"
    click_on "Back"
  end

  test "destroying a Estimate" do
    visit estimates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Estimate was successfully destroyed"
  end
end
