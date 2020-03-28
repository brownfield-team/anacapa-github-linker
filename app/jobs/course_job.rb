require 'Octokit_Wrapper'

class CourseJob < BackgroundJob
  @permission_level = "instructor"
  @job_description = "Course Job"
  @course

  attr_accessor :course

  def create_in_progress_job_record
    super
    @job_record.course_id = @course.id
    @job_record.save
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end

  def slack_machine_user
    # TODO: Refactor this into a helper?
    Slack::Web::Client.new({ :token => @course.slack_workspace.bot_access_token })
  end

  # TODO: Refactor so that all #attempt_job's return a string summary and perform updates the db record.
  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @course = Course.find(course_id)
      create_in_progress_job_record
      begin
        summary = attempt_job || empty_job_summary
        update_job_record_with_completion_summary(summary)
      rescue Exception => e
        rescue_job(e)
      end
    end
  end

  def attempt_job

  end
end
