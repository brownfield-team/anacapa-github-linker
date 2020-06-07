class Courses::GithubWebhooksController
  class MembershipHook
    def self.process_hook(course, payload)
      existing_team_record = OrgTeam.find_by_team_id(payload[:team][:node_id])
      return if existing_team_record.nil?
      case payload[:action]
      when "added"
        add_student_to_team_if_found(course, existing_team_record, payload)
      when "removed"
        student = course.student_for_uid(payload[:member][:id])
        return if student.nil?
        StudentTeamMembership.where(roster_student: student, org_team: existing_team_record).first.try(:destroy)
      else
        return
      end
    end

    def self.add_student_to_team_if_found(course, team, payload)
      student_member = course.student_for_uid(payload[:member][:id])
      return if student_member.nil?
      response = github_machine_user.post '/graphql', { query: team_member_role_query(team.slug) }.to_json
      team_members = response.data.organization.team.members.edges
      found_member = team_members.find { |m| m.node.databaseId == student_member.user.uid.to_i }
      return if found_member.nil?
      membership = StudentTeamMembership.where(org_team: team, roster_student: student_member).first_or_initialize
      membership.role = found_member.role.downcase
      membership.save
    end

    def self.team_member_role_query(team_slug)
      <<-GRAPHQL
      query { 
        organization(login:"#{@course.course_organization}") {
          team(slug:"#{team_slug}") {
            members {
              edges {
                role
                node {
                  databaseId
      } } } } } }
      GRAPHQL
    end
  end
end