class AssociateSlackUsersJob < CourseJob
  @job_name = "Associate Slack Users With Students"
  @job_short_name = "associate_slack_users"
  @job_description = "Fetches a list of users in the linked Slack workspace and associates them by email with students in the course."

  def attempt_job
    # TODO: Enable pagination of users list
    users_response = slack_machine_user.users_list
    unless users_response.respond_to? :ok && users_response.ok
      puts users_response
      return "Slack API request failed. Please check the log or try again."
    end
    slack_members = users_response.members
    associations_created = 0; associations_updated = 0
    slack_members.each do |member|
      if member.profile.respond_to? :email
        slack_user_record = SlackUser.find_by_uid(member.id)
        if slack_user_record.nil?
          email = member.profile.email.include? "@ucsb.edu" ? member.profile.email.sub("@ucsb.edu", "@umail.ucsb.edu") : member.profile.email
          corresponding_student = RosterStudent.where(course_id: @course.id, email: email).first
          if corresponding_student.nil? then next end
          associations_created += 1
          slack_user_record = SlackUser.new(uid: member.id, roster_student_id: corresponding_student.id)
        else
          associations_updated += 1
        end
        slack_user_record.username = member.name
        slack_user_record.display_name = member.profile.display_name
        slack_user_record.save
      end
    end
    "#{pluralize associations_created, "association"} created between students and Slack users, #{associations_updated} refreshed."
  end
end