class TestJob
  include SuckerPunch::Job

  def perform(url_triggered_from, course_id)
    CompletedJob.create(job_name: "Test Job", url_triggered_from: url_triggered_from,
                        course_id: course_id)
  end
end
