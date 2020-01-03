class TestJob < CourseJob

  @job_name = "Test Job"
  @job_short_name = "test_job"

  def perform(course_id)
    create_completed_job_record("Test completed.", course_id)
  end
end
