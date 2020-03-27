class TestJob < CourseJob

  @job_name = "Test Job"
  @job_short_name = "test_job"
  @job_description = "Adds a completed job record for this course for testing purposes."

  def attempt_job
    "Test completed."
  end
end
