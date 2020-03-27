class RefreshGithubTeamsJob < CourseJob
  @job_name = "Refresh GitHub Teams"
  @job_short_name = "refresh_github_teams"
  @job_description = "Refreshes GitHub teams associated with this course's organization and updates their membership."

  def attempt_job
    course_student_users = @course.roster_students.map.select { |student| student.user.present? }
    results = refresh_teams(course_student_users)
    "#{results[:num_created]} teams created, #{results[:num_updated]} updated."
  end

  def refresh_teams(students_with_users)
    results = { :num_created => 0, :num_updated => 0 }
    all_org_teams = get_org_teams(@course.course_organization).map { |team| team.node}
    all_org_teams.each do |team|
      team_to_update = OrgTeam.find_by_team_id(team.id)
      if team_to_update.nil?
        team_to_update = OrgTeam.new(team_id: team.id, course_id: @course.id)
        results[:num_created] += 1
      else
        results[:num_updated] += 1
      end
      team_to_update.name = team.name
      team_to_update.slug = team.slug
      team_to_update.url = team.url
      team_to_update.save

      team_members = get_team_members(@course.course_organization, team_to_update)
      team_members.each do |team_member|
        student_for_member = students_with_users.select { |rs| rs.user.uid == team_member.node.databaseId.to_s }.first
        if student_for_member.present?
          team_membership_record = StudentTeamMembership.find_by(roster_student_id: student_for_member.id, org_team_id: team_to_update.id)
          if team_membership_record.nil?
            team_membership_record = StudentTeamMembership.new(roster_student_id: student_for_member.id, org_team_id: team_to_update.id)
          end
          team_membership_record.role = team_member.role.downcase
          team_membership_record.save
        end
      end
    end
    results
  end

  def get_org_teams(course_org, cursor = "")
    response = github_machine_user.post '/graphql', { query: team_list_graphql_query(course_org, cursor) }.to_json
    team_list = team_list_from_response(response)
    if team_list.count < 100
      return team_list
    end
    team_list + get_org_teams(course_org, team_list.last.cursor)
  end

  def team_list_from_response(response)
    response.data.organization.teams.edges
  end

  def team_list_graphql_query(course_org, team_cursor = "")
    team_after_arg = team_cursor != "" ? ", after: \"#{team_cursor}\"" : ""
    <<-GRAPHQL
    query {
      organization(login:"#{course_org}") {
        teams(first: 100#{team_after_arg}) {
          edges {
            cursor
            node {
              name
              url
              slug
              id
    } } } } }
    GRAPHQL
  end

  def get_team_members(course_org, team_record, cursor = "")
    response = github_machine_user.post '/graphql', { query: team_membership_graphql_query(course_org, team_record.slug, cursor) }.to_json
    member_list = member_list_from_team_response(response)
    if member_list.count < 100
      return member_list
    end
    member_list + get_team_members(course_org, team_record, member_list.last.cursor)
  end

  def member_list_from_team_response(team_response)
    team_response.data.organization.team.members.edges
  end

  def team_membership_graphql_query(course_org, team_slug, member_cursor = "")
    member_after_arg = member_cursor != "" ? ", after: \"#{member_cursor}\"" : ""
    <<-GRAPHQL
    query {
      organization(login:"#{course_org}") {
        team(slug:"#{team_slug}") {
          members(first: 100#{member_after_arg}) {
            edges {
              role
              node {
                databaseId
    } } } } } }
    GRAPHQL
  end
end
