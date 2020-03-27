class AssociateSlackUsersJob < CourseJob
  @job_name = "Associate Slack Users With Students"
  @job_short_name = "associate_slack_users"
  @job_description = "Fetches a list of users in the linked Slack workspace and associates them by email with students in the course."

  def attempt_job
    # Remember to check that id is not USLACKBOT
    users_response = slack_machine_user.users_list
    unless users_response.respond_to? :ok && users_response.ok
      puts users_response
      update_job_record_with_completion_summary("Slack API request failed. Please check the log or try again.")
      return
    end
    slack_members = users_response.members
    slack_members.each do |member|
      if member.respond_to?(:profile) && member.profile.respond_to?(:email)

      end
    end
  end
end