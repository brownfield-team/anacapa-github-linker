class UpdateGithubReposJob < CourseJob
  @job_name = "Refresh GitHub Repository Info"
  @job_short_name = "update_github_info"
  @job_description = "Uses smart querying to quickly update GitHub repositories, and their respective individual and team collaborators."

  def attempt_job(course_id)
    course = Course.find(course_id)
    course_student_users = course.users

    all_org_repos = get_github_repos(course.course_organization).map { |repo| repo.node}
    num_created = 0; collaborators_found = 0; repos_found_collaborators_for = 0

    all_org_repos.each do |repo|
      num_created += create_or_update_repo(repo, course_id)

      num_repo_collaborators = create_or_update_collaborators(repo, course_student_users)
      collaborators_found += num_repo_collaborators
      repos_found_collaborators_for += num_repo_collaborators > 0 ? 1 : 0
    end
    num_updated = all_org_repos.count - num_created

    team_refresh_results = refresh_team_collaborators(course)

    summary = "#{num_created} repos created, #{num_updated} refreshed. #{collaborators_found} collaborators and
#{team_refresh_results} teams found for #{repos_found_collaborators_for} repos."
    update_job_record_with_completion_summary(summary)
  end
  
  def create_or_update_repo(github_repo, course_id)
    existing_record = GithubRepo.find_by_repo_id(github_repo.databaseId)
    unless existing_record.nil?
      num_created = 0
      repo_record = existing_record
    else
      num_created = 1
      repo_record = GithubRepo.new
      repo_record.repo_id = github_repo.databaseId
      repo_record.course_id = course_id
    end
    repo_record.name = github_repo.name
    repo_record.full_name = github_repo.nameWithOwner  # full_name includes organization name e.g. test-org/test-repo
    repo_record.visibility = github_repo.isPrivate ? "private" : "public"
    repo_record.url = github_repo.url
    repo_record.last_updated_at = github_repo.updatedAt
    repo_record.save

    num_created
  end

  def create_or_update_collaborators(github_repo, course_student_users)
    usernames = course_student_users.map { |user| user.username }
    db_repo_record = GithubRepo.find_by_repo_id(github_repo.databaseId)

    collaborator_list = collaborator_list_from_response_repo(github_repo)
    filtered_collaborator_list = collaborator_list.select { |collaborator| usernames.include?(collaborator.node.login) }

    filtered_collaborator_list.each do |collaborator|
      user = course_student_users.select { |user| user.username == collaborator.node.login }.first
      existing_record = RepoContributor.find_by(user_id: user.id, github_repo_id: db_repo_record.id)
      unless existing_record.nil?
        current_record = existing_record
      else
        current_record = RepoContributor.new(user: user, github_repo: db_repo_record)
      end
      current_record.permission_level = collaborator.permission.downcase
      current_record.save
    end
    filtered_collaborator_list.count
  end

  # TODO: Figure out how to refactor this GraphQL handling code so it doesn't have to be constantly repeated
  # We have to manually handle pagination because Octokit has no built-in support for GraphQL
  def get_github_repos(course_org, cursor = "")
    response = github_machine_user.post '/graphql', { query: repository_graphql_query(course_org, cursor) }.to_json
    repo_list = repo_list_from_response(response)
    if repo_list.count < 100 # If there are less than 100 records (max page size), this is the last page
      return repo_list
    end
    repo_list + get_github_repos(course_org, repo_list.last.cursor)
  end

  def repo_list_from_response(response)
    response.data.organization.repositories.edges
  end

  def collaborator_list_from_response_repo(repo_response)
    repo_response.collaborators.edges
  end

  def repository_graphql_query(course_org, cursor)
    after_arg = cursor != "" ? ", after: \"#{cursor}\"" : ""
    <<-GRAPHQL
      query {
        organization(login:"#{course_org}") {
          repositories(first: 100#{after_arg}) {
            edges {
              cursor
              node {
                name
                databaseId
                url
                nameWithOwner
                updatedAt
                isPrivate
                collaborators(affiliation:DIRECT) {
                  edges {
                    permission
                    node {
                      login
      } } } } } } } }
    GRAPHQL
  end

  def refresh_team_collaborators(course)
    team_collaborators_found = 0
    all_org_teams = get_org_teams(course.course_organization).map { |team| team.node}
    all_org_teams.each do |team|
      team_to_update = OrgTeam.find_by_team_id(team.id)
      unless team_to_update.nil?
        team_collaborators_found += update_team_repo_collaborators(team_to_update, repo_list_from_response_team(team))
      end
    end
    team_collaborators_found
  end

  def update_team_repo_collaborators(team_record, repo_list)
    num_repos_collaborator_for = 0
    repo_list.each do |repo|
      repo_record = GithubRepo.find_by_repo_id(repo.node.databaseId)
      unless repo_record.nil?
        contributor_record = RepoTeamContributor.find_by(org_team_id: team_record.id, github_repo_id: repo_record.id)
        if contributor_record.nil?
          contributor_record = RepoTeamContributor.new(org_team_id: team_record.id, github_repo_id: repo_record.id)
        end
        contributor_record.permission_level = repo.permission.downcase
        contributor_record.save
        num_repos_collaborator_for += 1
      end
    end
    num_repos_collaborator_for
  end

  def get_org_teams(course_org, cursor = "")
    response = github_machine_user.post '/graphql', { query: team_graphql_query(course_org, cursor) }.to_json
    team_list = team_list_from_response(response)
    if team_list.count < 100
      return team_list
    end
    team_list + get_org_teams(course_org, team_list.last.cursor)
  end

  def team_list_from_response(response)
    response.data.organization.teams.edges
  end

  # Note that there is a known bug where, if a team has more than 100 repos, those after 100 will not be shown.
  # This is because of GraphQL paginating a list within a list, and this is enough of an edge case that it isn't worth
  # the development time it would cost right now.
  def repo_list_from_response_team(team_response)
    team_response.repositories.edges
  end

  def team_graphql_query(course_org, team_cursor = "")
    team_after_arg = team_cursor != "" ? ", after: \"#{team_cursor}\"" : ""
    repo_after_arg = ""
    <<-GRAPHQL
    query {
      organization(login:"#{course_org}") {
        teams(first: 100#{team_after_arg}) {
          edges {
            cursor
            node {
              id
              repositories(first: 100#{repo_after_arg}) {
                edges {
                  cursor
                  permission
                  node {
                    databaseId
    } } } } } } } }
    GRAPHQL
  end

end