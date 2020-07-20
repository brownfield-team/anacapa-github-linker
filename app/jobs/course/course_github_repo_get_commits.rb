class CourseGithubRepoGetCommits < CourseGithubRepoJob

    @job_name = "Get Commits for this Repo"
    @job_short_name = "course_github_repo_get_commits"
    @job_description = "Get commits for this repo"
    

    def attempt_job(options)
      results = perform_graphql_query(@github_repo.name,@course.course_organization)
      commits = results[:data][:repository][:ref][:target][:history][:edges]
      result = store_commits_in_database(commits)
      "Job Complete; Retrieved #{commits.length} commits for Course #{@course.name} for Repo #{@github_repo.name}. Stored #{result["total_new_commits"]} new commits, Updated #{result["total_updated_commits"]} existing commits in database."
    end  

    def store_commits_in_database(commits)
      total_new_commits = 0
      total_updated_commits = 0
      commits.each{ |c|
        existing_commit = RepoCommitEvent.where(commit_hash: c[:node][:oid]).first
        if existing_commit
          total_updated_commits += update_one_commit(existing_commit, c)
        else
          total_new_commits += store_one_commit_in_database(c) 
        end
      }
      result = { 
        "total_new_commits" => total_new_commits,
        "total_updated_commits" => total_updated_commits
      }
      result
    end

    def store_one_commit_in_database(c)
    
      commit = RepoCommitEvent.new
      commit.files_changed = c[:node][:changedFiles]
      commit.message = c[:node][:message]
      commit.commit_hash =  c[:node][:oid]
      commit.url =  c[:node][:url]
      commit.commit_timestamp =  c[:node][:author][:date]
      commit.github_repo = @github_repo
      commit.branch = "master"
      begin  # "try" block
        uid = c[:node][:author][:user][:databaseId]
        commit.roster_student = lookup_roster_student_by_github_uid(uid)
      rescue # optionally: `rescue Exception => ex`
        uid = ""
        commit.roster_student = nil
      end 
      begin
        commit.save!
        return 1
      rescue
        return 0
      end
    end

    def update_one_commit(commit, c)
      commit.files_changed = c[:node][:changedFiles]
      commit.message = c[:node][:message]
      commit.commit_hash =  c[:node][:oid]
      commit.url =  c[:node][:url]
      commit.commit_timestamp =  c[:node][:author][:date]
      commit.github_repo = @github_repo
      commit.branch = "master"
      begin  # "try" block
        uid = c[:node][:author][:user][:databaseId]
        commit.roster_student = lookup_roster_student_by_github_uid(uid)
      rescue # optionally: `rescue Exception => ex`
        uid = ""
        commit.roster_student = nil
      end 
      begin
        commit.save!
        return 1
      rescue
        return 0
      end
    end

    def lookup_roster_student_by_github_uid(uid)
      @course.student_for_uid(uid)
    end

    def create_commit_record(commit)
      RepoCommitEvent.new(

      )
    end

    def perform_graphql_query(repo_name, org_name)
      github_machine_user.post '/graphql', { query: graphql_query(repo_name, org_name) }.to_json
    end

    def graphql_query(repo_name, org_name)
        <<-GRAPHQL
        query { 
            repository(name: "#{repo_name}", owner: "#{org_name}") {
              ref(qualifiedName: "master") {
                target {
                  ... on Commit {
                    id
                    history(first: 100) {
                      pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                      }
                      edges {
                        node {
                          changedFiles
                          messageHeadline
                          oid
                          message
                          url
                          author {
                            user {
                                login
                                databaseId
                            }
                            name
                            email
                            date
                          }
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
  