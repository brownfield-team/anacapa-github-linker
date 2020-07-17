class PurgeUnusedUsersJob < AdminJob

  @job_name = "Purge Unenrolled Student Users"
  @job_short_name = "purge_unenrolled_users"
  @confirmation_dialog = "Are you sure you want to delete all non-admin/instructor users not enrolled in a course?"
  @job_description = "Removes all users who are not instructors/admins that are not enrolled in any existing course."

  def attempt_job(options)
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
    "#{pluralize num_removed, "user"} purged from the database."
  end
end