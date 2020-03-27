require 'Octokit_Wrapper'

class CourseJob < BackgroundJob
  @permission_level = "instructor"
  @job_description = "Course Job"
  @course

  def create_in_progress_job_record
    # TODO: This is no longer an overload, and can probably be replaced with cleaner syntax.
    # This is a horrifying way to call the superclass method create_in_progress_job_record(),
    # but it would seem this is the only way to call an overloaded parent method in Ruby. Strange design.
    # Source: https://stackoverflow.com/a/8616695/3950780
    BackgroundJob.instance_method(:create_in_progress_job_record).bind(self).call
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

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @course = Course.find(course_id)
      create_in_progress_job_record
      begin
        attempt_job
      rescue Exception => e
        rescue_job(e)
      end
    end
  end

  def attempt_job

  end
end
