class PurgeUnusedUsersJob < AdminJob
  @job_name = "Purge Unenrolled Student Users"
  @job_short_name = "purge_unenrolled_users"

  def perform
    super
    num_removed = 0
    users = User.all
    users.each do |user|
      if user.roster_students.size == 0
        unless is_instructor_or_admin(user)
          user.destroy
          num_removed += 1
        end
      end
    end
    summary = num_removed.to_s + " users purged from the database."
    update_job_record_with_completion_summary(summary)
  end

  # Slightly hacky way to tell whether user is an instructor as the user.has_role function
  # requires a specific course to correctly tell whether a user has an instructor role.
  # We want to know if the user is an instructor for ANY course.
  def is_instructor_or_admin(user)
    user.roles.each { |role| return true if role.name == "admin" || role.name == "instructor" }
    false
  end

end