class PurgeCourseReposJob < CourseJob

  @job_name = "Purge Course GitHub Repo Records"
  @job_short_name = "purge_course_repos"
  @job_description = "Removes all cached records of this course organization's GitHub repos from the database."

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      super
      destroyed_repos = GithubRepo.where(:course_id => course_id.to_i).destroy_all
      summary = "Purged " + destroyed_repos.size.to_s + " records from the database."
      update_job_record_with_completion_summary(summary)
    end
  end

end