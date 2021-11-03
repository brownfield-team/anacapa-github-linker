class CreateAssignmentReposJob < CourseJob
  @job_name = "Create Assignment Repositories"
  @job_short_name = "create_assignment_repos"
  @job_description = "Creates a repository for the given assignment for each roster student"

  def attempt_job(options)
    @visibility = options[:visibility].upcase
    @permission_level = options[:permission_level].downcase
    @assignment_name = options[:assignment_name]
    @org_id = get_org_node_id
    
    roster_students = @course.roster_students.to_a.select { |rs|
      !rs.is_ta? && rs.user && rs.user.username
    }
    repos_created = 0
    repos_updated = 0

    roster_students.each do |rs|
      repo_name = "#{@assignment_name}-#{rs.user.username}"
      Rails.logger.info "Attempting to create: #{repo_name}"
      repos_created += create_assignment_repo(repo_name, rs)
      repos_updated += add_repository_contributor(repo_name, rs.user.username)
      
      if "#{ENV['SLEEP_TIME']}"
        sleep_time = "#{ENV['SLEEP_TIME']}".to_i
        Rails.logger.info "SLEEP_TIME set, sleeping #{sleep_time}"
        sleep sleep_time
      end
    end
    "For #{pluralize roster_students.length, "roster student"}, #{pluralize repos_created, "repository"} created and permissions updated for #{pluralize repos_updated, "repository"} for assignment #{@assignment_name} with student permission level #{@permission_level}"
  end

  def create_assignment_repo(repo_name, roster_student)
    begin
      response = github_machine_user.post "/graphql", { query: create_assignment_repo_query(repo_name) }.to_json
      if !response.respond_to?(:data) || response.respond_to?(:errors)
        puts "CREATION ERROR for #{repo_name} for user #{roster_student.user.username} #{response.to_h}"
        return 0
      end
      new_repo_full_name = get_repo_name_and_create_record(response, roster_student)
    rescue Exception => e
      puts "CREATION ERROR with #{repo_name} for user #{roster_student.user.username} #{e}"
      return 0
    end
    1
  end

  def add_repository_contributor(repo_name, username)
    begin
      url = "/repos/#{@course.course_organization}/#{repo_name}/collaborators/#{username}"
      puts "\n\nadd_repository_contributor, url=#{url}"
      result = github_machine_user.put(url, { "permission": "#{@permission_level}" })
      puts "\n\nadd_repository_contributor, result=#{result.to_json}"
    rescue Exception => e
      puts "PERMISSION ERROR with #{repo_name} for user #{username} #{e}"
      return 0
    end
    1
  end

  def create_assignment_repo_query(repo_name)
    <<-GRAPHQL
        mutation {
          createRepository(input:{
            visibility: #{@visibility}
            ownerId:"#{@org_id}"
            name:"#{repo_name}"
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

  def get_repo_name_and_create_record(response, roster_student)
    repoInfo = response.data.createRepository.repository

    new_repo = GithubRepo.create(name: repoInfo.name, url: repoInfo.url, full_name: repoInfo.nameWithOwner,
                                 course_id: @course.id, visibility: @visibility.downcase, repo_id: repoInfo.databaseId)
    RepoContributor.create(user: roster_student.user, github_repo: new_repo, permission_level: @permission_level)
    new_repo.full_name
  end

  def get_org_node_id
    response = github_machine_user.post "/graphql", { query: org_node_id_query }.to_json
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
