class AssociateSlackUsersJob < CourseJob
  @job_name = "Associate Slack Users With Students"
  @job_short_name = "associate_slack_users"
  @job_description = "Fetches a list of users in the linked Slack workspace and associates them by email with students in the course."

  def attempt_job
    users = slack_machine_user.users_list
    puts(users)
  end
end