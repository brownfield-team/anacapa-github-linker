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
  @permission_level

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

  def self.permission_level
    @permission_level
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
    ActiveRecord::Base.connection_pool.with_connection do
      begin
        create_in_progress_job_record
        attempt_job
      rescue Exception => e
        rescue_job(e)
      end
    end
  end

  def attempt_job
    # What a job actually does

  end

  def rescue_job(exception)
    # Update job log record and reraise exception
    if ENV['DEBUG_VERBOSE'] && ENV['DEBUG_VERBOSE'].to_i >= 1
      update_job_record_with_completion_summary(exception.to_s)
    else
      update_job_record_with_completion_summary("An exception occurred. Please see the logs for more info.")
    end
    raise exception
  end
end
