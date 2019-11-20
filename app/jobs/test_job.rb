class TestJob < CourseJob

  @job_name = "Test Job"

  def perform(course_id)
    CompletedJob.create(job_name: "Test Job", summary: "Test completed.",
                        course_id: course_id)
    if CompletedJob.where('course_id = ' + course_id.to_s).count > 10
      CompletedJob.where('course_id = ' + course_id.to_s).order(:created_at).first.destroy
    end
  end
end
