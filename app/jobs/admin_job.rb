class AdminJob < BackgroundJob
  @confirmation_dialog = "Are you sure you want to run this job?"
  @job_description = "Admin Job"

  def self.confirmation_dialog
    @confirmation_dialog
  end

  def perform
    create_in_progress_job_record
  end
end