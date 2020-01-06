class PurgeCompletedJobsJob < AdminJob

  @job_name = "Purge All Completed Job Records"
  @job_short_name = "purge_completed_jobs"
  @confirmation_dialog = "Are you sure you want to delete all records of completed jobs?"

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      super
      CompletedJob.destroy_all
    end
  end
end