class CreateTeamReposJob < CourseJob
  @job_name = "Create Team Repositories"
  @job_short_name = "create_team_repos"
  @job_description = "Creates a repository named with the provided name pattern for each team matching a specified team name pattern"

  def attempt_job(options)
    @visibility = options[:visibility].upcase
    @permission_level = options[:permission_level].downcase
    @org_id = get_org_node_id

    matching_teams = OrgTeam.where(course_id: @course.id).where("name ~* ?", options[:team_pattern])
    repos_created = 0
    repos_permissions_updated = 0
    matching_teams.each do |team|
      repo_name = options[:repo_pattern].sub("{team}", team.slug)
      repos_created += create_team_repo(repo_name, team)
      repos_permissions_updated += update_permissions_team_repo(repo_name, team)
    end

    "#{pluralize repos_created, "repository"} created and permissions updated for #{pluralize repos_permissions_updated, "repository"} with team permission level #{@permission_level}."
  end

  def create_team_repo(repo_name, team)
    begin
      response = github_machine_user.post '/graphql', { query: create_team_repo_query(repo_name, team.team_id) }.to_json
      if !response.respond_to?(:data) || response.respond_to?(:errors)
        return 0
      end
      new_repo_full_name = get_repo_name_and_create_record(response, team.id)
    rescue Exception => e
      puts "CREATION ERROR with #{repo_name} for team #{team} #{e}"
      return 0
    end
    1
  end

  def update_permissions_team_repo(repo_name, team)
    begin
      github_machine_user.put("/orgs/#{@course.course_organization}/teams/#{team.slug}/repos/#{repo_name}", {"permission": "#{@permission_level}"})
    rescue Exception => e
      puts "PERMISSION ERROR with #{repo_name} for team #{team} #{e}"
    end
    1
  end

  def create_team_repo_query(repo_name, team_id)
    <<-GRAPHQL
      mutation {
        createRepository(input:{
          visibility: #{@visibility}
          ownerId:"#{@org_id}"
          name:"#{repo_name}"
          teamId:"#{team_id}"
        }) {
          repository {
            name
            url
            nameWithOwner
            databaseId
          }
        }
      }
    GRAPHQL
  end

  def get_repo_name_and_create_record(response, team_record_id)
    repoInfo = response.data.createRepository.repository

    new_repo = GithubRepo.create(name: repoInfo.name, url: repoInfo.url, full_name: repoInfo.nameWithOwner,
                              course_id: @course.id, visibility: @visibility.downcase, repo_id: repoInfo.databaseId)
    RepoTeamContributor.create(org_team_id: team_record_id, github_repo_id: new_repo.id, permission_level: @permission_level)
    new_repo.full_name
  end

  def get_org_node_id
    response = github_machine_user.post '/graphql', { query: org_node_id_query }.to_json
    response.data.organization.id
  end

  def org_node_id_query
    <<-GRAPHQL
      query {
        organization(login:"#{@course.course_organization}") {
          id
        }
      }
    GRAPHQL
  end
end