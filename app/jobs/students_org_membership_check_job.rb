class StudentsOrgMembershipCheckJob < CourseJob

  @job_name = "Refresh Student Org Membership"

  def perform(course_id)
    course = Course.find(course_id.to_i)
    org_member_ids = github_machine_user.organization_members(course.course_organization).map {|member|
      member.id}
    unless org_member_ids.respond_to? :each
      summary = "Failed to fetch org members from GitHub."
      CompletedJob.create(job_name: StudentsOrgMembershipCheckJob.job_name, course_id: course_id, summary: summary)
      return
    end

    roster_students = course.roster_students
    num_changed = 0
    roster_students.each do |student|
      unless student.user.uid.nil?
        if org_member_ids.include?(student.user.uid.to_i) != student.is_org_member
          student.is_org_member = !student.is_org_member
          num_changed = num_changed + 1
          student.save
        end
      end
    end
    CompletedJob.create(job_name: StudentsOrgMembershipCheckJob.job_name, course_id: course_id, summary: num_changed.to_s +
        " org membership statuses updated")
  end
end
