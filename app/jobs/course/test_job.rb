class TestJob < CourseJob

  @job_name = "Test Job"
  @job_short_name = "test_job"
  @job_description = "Adds a completed job record for this course for testing purposes."

  def attempt_job(course_id)
    update_job_record_with_completion_summary("Test completed.")
  end
end
