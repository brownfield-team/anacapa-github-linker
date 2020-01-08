class PurgeUnusedUsersJob < AdminJob

  @job_name = "Purge Unenrolled Student Users"
  @job_short_name = "purge_unenrolled_users"
  @confirmation_dialog = "Are you sure you want to delete all non-admin/instructor users not enrolled in a course?"

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      super
      num_removed = 0
      users = User.all
      users.each do |user|
        if user.roster_students.size == 0
          unless UsersHelper.instructor_or_admin?(user)
            user.destroy
            num_removed += 1
          end
        end
      end
      summary = num_removed.to_s + " users purged from the database."
      update_job_record_with_completion_summary(summary)
    end
  end

end