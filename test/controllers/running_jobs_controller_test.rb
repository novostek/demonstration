require 'test_helper'

class RunningJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @running_job = running_jobs(:one)
  end

  test "should get index" do
    get running_jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_running_job_url
    assert_response :success
  end

  test "should create running_job" do
    assert_difference('RunningJob.count') do
      post running_jobs_url, params: { running_job: { complete: @running_job.complete, redirect: @running_job.redirect } }
    end

    assert_redirected_to running_job_url(RunningJob.last)
  end

  test "should show running_job" do
    get running_job_url(@running_job)
    assert_response :success
  end

  test "should get edit" do
    get edit_running_job_url(@running_job)
    assert_response :success
  end

  test "should update running_job" do
    patch running_job_url(@running_job), params: { running_job: { complete: @running_job.complete, redirect: @running_job.redirect } }
    assert_redirected_to running_job_url(@running_job)
  end

  test "should destroy running_job" do
    assert_difference('RunningJob.count', -1) do
      delete running_job_url(@running_job)
    end

    assert_redirected_to running_jobs_url
  end
end
