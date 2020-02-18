class StudentsOrgMembershipCheckJob < CourseJob

  @job_name = "Refresh Student Org Membership Statuses"
  @job_short_name = "refresh_org_membership"
  @job_description = "Updates all students' cached GitHub org membership status in the database/"

  def attempt_job(course_id)
    course = Course.find(course_id)
    org_members = get_org_members(course.course_organization)
    num_changed = 0
    org_members.each do |member|
      num_changed += update_org_membership_status(member, course.roster_students)
    end
    summary = num_changed.to_s + " org membership statuses updated"
    update_job_record_with_completion_summary(summary)
  end

  def update_org_membership_status(org_member, students)
    updates_made = false
    student = students.find do |s|
      s.user.present? && s.user.username == org_member.node.login
    end
    if student.nil?
      return 0
    end
    if !student.is_org_member || student.org_membership_type != org_member.role
      updates_made = true
      student.is_org_member = true
      student.org_membership_type = org_member.role
    end
    updates_made ? 1 : 0
  end
  
  # TODO: Refactor some GraphQL handling code (especially re: pagination) to the extent possible to avoid repetition
  def get_org_members(course_org, cursor = "")
    response = github_machine_user.post '/graphql', {query: graphql_query(course_org, cursor)}.to_json
    member_list = member_list_from_response(response)
    if member_list.empty?
      return member_list
    end
    member_list + get_org_members(course_org, member_list.last.cursor)
  end

  def member_list_from_response(response)
    response.data.organization.membersWithRole.edges
  end

  def graphql_query(course_org, cursor)
    after_arg = cursor != "" ? ", after: \"#{cursor}\"" : ""
    <<-GRAPHQL
      query {
        organization(login:"#{course_org}") {
          membersWithRole(first:100#{after_arg}) {
            edges {
              cursor
              role
              node {
                login
              }
            }
          }
        }
      }
    GRAPHQL
  end

end
