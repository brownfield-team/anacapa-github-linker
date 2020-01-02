class StudentsOrgMembershipCheckJob < CourseJob

  @job_name = "Refresh Student Org Membership"
  @job_short_name = "refresh_org_membership"

  def perform(course_id)
    course = Course.find(course_id.to_i)
    org_member_ids = github_machine_user.organization_members(course.course_organization).map { |member| member.id }
    summary = ""
    unless org_member_ids.respond_to? :each
      summary = "Failed to fetch org members from GitHub."
    else
      roster_students = course.roster_students
      num_changed = 0
      roster_students.each do |student|
        unless student.user.uid.nil?
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
    create_completed_job_record(summary, course_id)
  end

end
