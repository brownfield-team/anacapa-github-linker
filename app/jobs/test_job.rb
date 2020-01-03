class TestJob < CourseJob

  @job_name = "Test Job"
  @job_short_name = "test_job"

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      create_completed_job_record("Test completed.", course_id)
    end
  end
end
