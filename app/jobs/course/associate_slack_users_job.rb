class AssociateSlackUsersJob < CourseJob
  @job_name = "Associate Slack Users With Students"
  @job_short_name = "associate_slack_users"
  @job_description = "Fetches a list of users in the linked Slack workspace and associates them by email with students in the course."

  def attempt_job(options)
    slack_members = []
    slack_machine_user.users_list do |response|
      slack_members.concat(response.members)
    end

    associations_created = 0; associations_updated = 0
    slack_members.each do |member|
      if member.profile.respond_to? :email
        slack_user_record = SlackUser.find_by_uid(member.id)
        if slack_user_record.nil?
          emails = [member.profile.email]
          if member.profile.email.include?("@ucsb.edu")
            emails << member.profile.email.sub("@ucsb.edu", "@umail.ucsb.edu")
          end
          corresponding_student = RosterStudent.where(course_id: @course.id, email: emails).first
          if corresponding_student.nil? then next end
          if corresponding_student.slack_user.present?
            # Student can only have one Slack user, delete the old one if the email has changed.
            corresponding_student.slack_user.destroy
          end
          associations_created += 1
          slack_user_record = SlackUser.new(uid: member.id, roster_student_id: corresponding_student.id, slack_workspace_id: @course.slack_workspace.id)
        else
          associations_updated += 1
        end
        slack_user_record.username = member.name
        if member.profile.respond_to?(:display_name) && member.profile.display_name != ""
          slack_user_record.display_name = member.profile.display_name
        else
          if member.profile.respond_to?(:real_name) && member.profile.real_name != ""
            slack_user_record.display_name = member.profile.real_name
          else
            # As a last resort, just use their username.
            slack_user_record.display_name = member.name
          end
        end
        slack_user_record.save
      end
    end
    "#{pluralize associations_created, "association"} created between students and Slack users, #{associations_updated} refreshed."
  end
end