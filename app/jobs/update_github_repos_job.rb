class UpdateGithubReposJob < CourseJob
  @job_name = "Update All GitHub info"
  @job_short_name = "update_github_info"
  @job_description = "Uses smart querying to quickly update GitHub repositories and their collaborators."

  def attempt_job(course_id)
    course = Course.find(course_id)
    course_student_users = course.roster_students.map { |rs| rs.user }.select { |u| u != nil }
    all_org_repos = get_github_repos(course.course_organization).map { |repo| repo.node}
    binding.pry
    all_org_repos.each do |repo|

    end

  end

  def create_or_update_repo(repo)

  end

  # We have to manually handle pagination because Octokit has no built-in support for GraphQL
  def get_github_repos(course_org, cursor = "")
    response = github_machine_user.post '/graphql', { query: graphql_query(course_org, cursor) }.to_json
    repo_list = repo_list_from_response(response)
    if repo_list.count == 0
      return repo_list
    end
    repo_list + get_github_repos(course_org, repo_list.last.cursor)
  end

  def repo_list_from_response(response)
    response.data.organization.repositories.edges
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
              id
              url
              nameWithOwner
              updatedAt
              isPrivate
              collaborators(affiliation:DIRECT) {
                edges {
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