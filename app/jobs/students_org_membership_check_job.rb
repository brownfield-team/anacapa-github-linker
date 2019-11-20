require 'Octokit_Wrapper'

class StudentsOrgMembershipCheckJob
  include SuckerPunch::Job

  def perform(course_id)
    course = Course.find(course_id)
    client = Octokit_Wrapper::Octokit_Wrapper.machine_user
    org_member_ids = client.organization_members(course.course_organization).map {|member| member.id}
    if org_member_ids.size == 0
      CompletedJob.create(job_name: "Refresh Student Org Membership", course_id: course_id, summary: "Failed to fetch
        user IDs from GitHub.")
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
    CompletedJob.create(job_name: "Refresh Student Org Membership", course_id: course_id, summary: num_changed.to_s +
        " org membership statuses updated")
  end
end
