class CreateTeamReposJob < CourseJob
  @job_name = "Create Team Repositories"
  @job_short_name = "create_team_repos"
  @job_description = "Creates a repository named with the provided name pattern for each team matching a specified team name pattern"

  def attempt_job(course_id, team_pattern, repo_pattern, permission_level, visibility)
    @course = Course.find(course_id)
    @visibility = visibility.upcase
    @permission_level = permission_level.downcase
    @org_id = get_org_node_id

    matching_teams = OrgTeam.where(course_id: @course.id).where("name ~* ?", team_pattern)
    repos_created = 0
    matching_teams.each do |team|
      repo_name = repo_pattern.sub("{team}", team.slug)
      repos_created += create_team_repo(repo_name, team)
    end

    summary = "#{repos_created} repositories created with team permission level #{@permission_level}."
    update_job_record_with_completion_summary(summary)
  end

  def create_team_repo(repo_name, team)
    response = github_machine_user.post '/graphql', { query: create_team_repo_query(repo_name, team.team_id) }.to_json
    unless response.respond_to? :data then return 0 end
    new_repo_full_name = get_repo_name_and_create_record(response, team.id)
    unless @permission_level == "read"
      github_machine_user.put("/orgs/#{@course.course_organization}/teams/#{team.slug}/repos/#{new_repo_full_name}", {"permission": "#{@permission_level}"})
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

  def perform(course_id, team_pattern, repo_pattern, permission_level, visibility)
    ActiveRecord::Base.connection_pool.with_connection do
      create_in_progress_job_record(course_id)
      begin
        attempt_job(course_id, team_pattern, repo_pattern, permission_level, visibility)
      rescue Exception => e
        rescue_job(e)
      end
    end
  end
end