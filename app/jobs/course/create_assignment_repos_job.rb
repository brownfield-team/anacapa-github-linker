class CreateAssignmentReposJob < CourseJob
    @job_name = "Create Assignment Repositories"
    @job_short_name = "create_assignment_repos"
    @job_description = "Creates a repository for the given assignment for each roster student"
  
    def attempt_job(options)
      @visibility = options[:visibility].upcase
      @permission_level = options[:permission_level].downcase
      @assignment_name = options[:assignment_name]
      @org_id = get_org_node_id
      @create_errors = 0
      @permission_errors = 0
      @db_errors = 0

      roster_students = @course.roster_students.to_a.select{ |rs|
        !rs.is_ta? && rs.user && rs.user.username
      }
      repos_created = 0
      roster_students.each do |rs|
          repo_name = "#{@assignment_name}-#{rs.user.username}" 
          repos_created += create_assignment_repo(repo_name, rs)
      end
      error_message = ( (@permission_errors + @create_errors + @db_errors) == 0 ) ? "" : " with #{@create_errors} create errors, #{@permission_errors} permission errors, and  #{@db_errors} db errors (see log)"
      "#{pluralize repos_created, "repository"} created for assignment #{@assignment_name} with student permission level #{@permission_level}. #{error_message}"
    end
  
    def create_assignment_repo(repo_name, roster_student)
      retval = 0
      begin
        response = github_machine_user.post '/graphql', { query: create_assignment_repo_query(repo_name)}.to_json
        if !response.respond_to?(:data) || response.respond_to?(:errors)
          puts "CREATION ERROR for #{repo_name} for user #{roster_student.user.username} #{response.to_h}"
          @create_errors += 1
        else
          begin
            new_repo_full_name = get_repo_name_and_create_record(response, roster_student)
          rescue Exception => e
            puts "DB ERROR with #{repo_name} for user #{roster_student.user.username} #{e}"
            @db_errors += 1
          end
        end
        retval = 1
      rescue Exception => e
        puts "CREATION ERROR with #{repo_name} for user #{roster_student.user.username} #{e}"
        @create_errors += 1
      end

      begin
        add_repository_contributor(repo_name,roster_student.user.username)
      rescue Exception => e
        puts "PERMISSION ERROR with #{repo_name} for user #{roster_student.user.username} #{e}"
        @permission_errors += 1
      end
      retval
    end
  
    def add_repository_contributor(repo_name,username)
      url = "/repos/#{@course.course_organization}/#{repo_name}/collaborators/#{username}"
      puts "\n\nadd_repository_contributor, url=#{url}"
      result = github_machine_user.put(url, {"permission": "#{@permission_level}"});
      puts "\n\nadd_repository_contributor, result=#{result.to_json}"
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