class PurgeCompletedJobsJob < AdminJob

  @job_name = "Purge All Completed Job Records"
  @job_short_name = "purge_completed_jobs"
  @confirmation_dialog = "Are you sure you want to delete all records of completed jobs?"
  @job_description = "Deletes all completed job records from the database."

  def attempt_job
    CompletedJob.destroy_all
  end
end