class UpdateGithubReposJob < CourseJob
  @job_name = "Update GitHub Repository Info"
  @job_short_name = "update_github_info"
  @job_description = "Uses smart querying to quickly update GitHub repositories and their collaborators."

  def attempt_job(course_id)
    course = Course.find(course_id)
    course_student_users = course.roster_students.map { |rs| rs.user }.compact
    all_org_repos = get_github_repos(course.course_organization).map { |repo| repo.node}

    num_created = 0; collaborators_found = 0; repos_found_collaborators_for = 0
    all_org_repos.each do |repo|
      num_created += create_or_update_repo(repo, course_id)
      num_repo_collaborators = create_or_update_collaborators(repo, course_student_users)
      collaborators_found += num_repo_collaborators
      repos_found_collaborators_for += num_repo_collaborators > 0 ? 1 : 0
    end
    num_updated = all_org_repos.count - num_created

    summary = "#{num_created} repos created, #{num_updated} refreshed. #{collaborators_found} collaborators found for
 #{repos_found_collaborators_for} repos."
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

  # We have to manually handle pagination because Octokit has no built-in support for GraphQL
  def get_github_repos(course_org, cursor = "")
    response = github_machine_user.post '/graphql', { query: graphql_query(course_org, cursor) }.to_json
    repo_list = repo_list_from_response(response)
    if repo_list.empty?
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

  def graphql_query(course_org, cursor)
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
                  }
                }
              }
            }
          }
        }
      }
    }
    GRAPHQL
  end
end