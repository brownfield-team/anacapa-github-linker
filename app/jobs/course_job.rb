require 'Octokit_Wrapper'

class CourseJob < BackgroundJob
  @permission_level = "instructor"

  @job_description = "Course Job"

  def create_in_progress_job_record(course_id)
    # This is a horrifying way to call the superclass method create_in_progress_job_record(),
    # but it would seem this is the only way to call an overloaded parent method in Ruby. Strange design.
    # Source: https://stackoverflow.com/a/8616695/3950780
    BackgroundJob.instance_method(:create_in_progress_job_record).bind(self).call
    @job_record.course_id = course_id
    @job_record.save
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end

  # TODO: Make this set a course instance variable to avoid code repetition
  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      create_in_progress_job_record(course_id)
      begin
        attempt_job(course_id)
      rescue Exception => e
        rescue_job(e)
      end
    end
  end

  def attempt_job(course_id)

  end
end
