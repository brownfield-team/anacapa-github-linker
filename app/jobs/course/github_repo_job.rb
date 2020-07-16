require 'Octokit_Wrapper'

class GithubRepoJob < CourseJob
  @job_description = "Github Repo Job"
  @github_repo


  def create_in_progress_job_record
    super
    @job_record.github_repo_id = @github_repo.id
    @job_record.save
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end

  def slack_machine_user
    # TODO: Refactor this into a helper?
    Slack::Web::Client.new({ :token => @course.slack_workspace.bot_access_token })
  end

  def perform(course_id, options = {})
    ActiveRecord::Base.connection_pool.with_connection do
      @course = Course.find(course_id)
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
