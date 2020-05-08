require "application_system_test_case"

class LaborCostsTest < ApplicationSystemTestCase
  setup do
    @labor_cost = labor_costs(:one)
  end

  test "visiting the index" do
    visit labor_costs_url
    assert_selector "h1", text: "Labor Costs"
  end

  test "creating a Labor cost" do
    visit labor_costs_url
    click_on "New Labor Cost"

    fill_in "Date", with: @labor_cost.date
    fill_in "Schedule", with: @labor_cost.schedule_id
    fill_in "Status", with: @labor_cost.status
    fill_in "Value", with: @labor_cost.value
    fill_in "Worker", with: @labor_cost.worker_id
    click_on "Create Labor cost"

    assert_text "Labor cost was successfully created"
    click_on "Back"
  end

  test "updating a Labor cost" do
    visit labor_costs_url
    click_on "Edit", match: :first

    fill_in "Date", with: @labor_cost.date
    fill_in "Schedule", with: @labor_cost.schedule_id
    fill_in "Status", with: @labor_cost.status
    fill_in "Value", with: @labor_cost.value
    fill_in "Worker", with: @labor_cost.worker_id
    click_on "Update Labor cost"

    assert_text "Labor cost was successfully updated"
    click_on "Back"
  end

  test "destroying a Labor cost" do
    visit labor_costs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Labor cost was successfully destroyed"
  end
end
