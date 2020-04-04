class AdminJob < BackgroundJob
  @confirmation_dialog = "Are you sure you want to run this job?"
  @job_description = "Admin Job"
  @permission_level = "admin"

  def self.confirmation_dialog
    @confirmation_dialog
  end

end
