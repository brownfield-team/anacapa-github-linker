require 'Octokit_Wrapper'

class CourseGithubRepoJob < CourseJob
  @permission_level = "instructor"
  @job_description = "Course Github Repo Job"
  @github_repo

  attr_accessor :course

  def create_in_progress_job_record
    super
    @job_record.github_repo_id = @github_repo.id
    @job_record.save
  end

  def perform(course_id, github_repo_id, options = {})
    ActiveRecord::Base.connection_pool.with_connection do
      @course = Course.find(course_id)
      @github_repo = GithubRepo.find(github_repo_id)
      create_in_progress_job_record
      begin
        summary = attempt_job(options) || empty_job_summary
        update_job_record_with_completion_summary(summary)
      rescue StandardError => e
        rescue_job(e)
      end
    end
  end
end
