require 'Octokit_Wrapper'

class CourseJob
  include SuckerPunch::Job

  # Job name: display name of job
  # Job short name: internal job name. Do not change this, it will break the job history
  @job_name
  @job_short_name

  def self.job_name
    @job_name
  end

  def self.job_short_name
    @job_short_name
  end

  def self.last_run
    if CompletedJob.where(job_short_name: @job_short_name).last.nil?
      return "N/A"
    end
    CompletedJob.where(job_short_name: @job_short_name).last.created_at
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end

  def create_completed_job_record(summary, course_id)
    job_record = CompletedJob.new
    job_record.job_name = self.class.job_name
    job_record.job_short_name = self.class.job_short_name
    job_record.summary = summary
    job_record.course_id = course_id.to_i
    job_record.save
  end

  def perform(course_id)

  end
end
