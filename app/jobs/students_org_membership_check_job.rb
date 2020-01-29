class StudentsOrgMembershipCheckJob < CourseJob

  @job_name = "Refresh Student Org Membership Statuses"
  @job_short_name = "refresh_org_membership"
  @job_description = "Updates all students' cached GitHub org membership status in the database/"

  def attempt_job(course_id)
    course = Course.find(course_id)
    org_member_ids = github_machine_user.organization_members(course.course_organization).map { |member| member.id }
    summary = ""
    unless org_member_ids.respond_to? :each
      summary = "Failed to fetch org members from GitHub."
    else
      roster_students = course.roster_students
      num_changed = 0
      roster_students.each do |student|
        unless student.user.nil? or student.user.uid.nil?
          is_org_member = org_member_ids.include?(student.user.uid.to_i)
          if is_org_member != student.is_org_member
            student.is_org_member = is_org_member
            num_changed += 1
            student.save
          end
        end
      end
      summary = num_changed.to_s + " org membership statuses updated"
    end
    update_job_record_with_completion_summary(summary)
  end

end
