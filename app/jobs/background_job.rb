# BackgroundJob is the superclass of all SuckerPunch job routines run in this app.
# It contains several methods and variables useful to all jobs

class BackgroundJob
  include SuckerPunch::Job

  # Job name: display name of job
  # Job short name: internal job name. Do not change this, it will break the job history
  @job_name
  @job_short_name
  @job_record
  @job_description

  def self.job_name
    @job_name
  end

  def self.job_short_name
    @job_short_name
  end

  def self.job_description
    @job_description
  end

  def self.last_run
    if CompletedJob.where(job_short_name: @job_short_name).last.nil?
      return "N/A"
    end
    CompletedJob.where(job_short_name: @job_short_name).last.created_at
  end

  def create_in_progress_job_record
    job_record = CompletedJob.new
    job_record.job_name = self.class.job_name
    job_record.job_short_name = self.class.job_short_name
    job_record.summary = "In progress"
    job_record.save
    @job_record = job_record
  end

  def update_job_record_with_completion_summary(summary)
    job_record = @job_record
    job_record.summary = summary
    job_record.save
  end

  def perform

  end
end