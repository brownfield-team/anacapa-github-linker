class AdminJob < BackgroundJob
  def perform
    create_in_progress_job_record
  end
end