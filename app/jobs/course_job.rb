require 'Octokit_Wrapper'

class CourseJob
  include SuckerPunch::Job

  @job_name

  def self.job_name
    @job_name
  end

  def self.last_run
    if CompletedJob.where(job_name: @job_name).last.nil?
      return "N/A"
    end
    CompletedJob.where(job_name: 'Refresh Student Org Membership').last.created_at
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end

  def create_completed_job_record(job_name, summary, course)
    job_record = CompletedJob.new
    job_record.job_name = job_name
    job_record.summary = summary
    job_record.course = course
    job_record.save
  end
end
