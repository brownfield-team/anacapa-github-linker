class TestJob < CourseJob

  @job_name = "Test Job"
  @job_short_name = "test_job"

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      super
      update_job_record_with_completion_summary("Test completed.")
    end
  end
end
