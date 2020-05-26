require "application_system_test_case"

class RunningJobsTest < ApplicationSystemTestCase
  setup do
    @running_job = running_jobs(:one)
  end

  test "visiting the index" do
    visit running_jobs_url
    assert_selector "h1", text: "Running Jobs"
  end

  test "creating a Running job" do
    visit running_jobs_url
    click_on "New Running Job"

    check "Complete" if @running_job.complete
    fill_in "Redirect", with: @running_job.redirect
    click_on "Create Running job"

    assert_text "Running job was successfully created"
    click_on "Back"
  end

  test "updating a Running job" do
    visit running_jobs_url
    click_on "Edit", match: :first

    check "Complete" if @running_job.complete
    fill_in "Redirect", with: @running_job.redirect
    click_on "Update Running job"

    assert_text "Running job was successfully updated"
    click_on "Back"
  end

  test "destroying a Running job" do
    visit running_jobs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Running job was successfully destroyed"
  end
end
