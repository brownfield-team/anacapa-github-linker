require 'json'
class CourseGithubRepoGetCommits < CourseGithubRepoJob

    @job_name = "Get Commits for this Repo"
    @job_short_name = "course_github_repo_get_commits"
    @job_description = "Get commits for this repo"
    @github_repo_full_name

    def result_hash(total, new_count, updated_count) 
      { 
        "total_commits" => total,
        "total_new_commits" => new_count,
        "total_updated_commits" => updated_count
      }
    end

    def combine_results(h1,h2) 
      {
        "total_commits" => h1["total_commits"] + h2["total_commits"],
        "total_new_commits" => h1["total_new_commits"] + h2["total_new_commits"],
        "total_updated_commits" => h1["total_updated_commits"] + h2["total_updated_commits"]
      }
    end

    def attempt_job(options)
      @github_repo_full_name = "#{@course.course_organization}/#{@github_repo.name}"      
      final_results = result_hash(0,0,0)
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_graphql_query(@github_repo.name,@course.course_organization,end_cursor)
        begin
          more_pages = query_results[:data][:repository][:ref][:target][:history][:pageInfo][:hasNextPage]
          end_cursor = query_results[:data][:repository][:ref][:target][:history][:pageInfo][:endCursor]
          commits = query_results[:data][:repository][:ref][:target][:history][:edges]
        rescue
          return "Unexpected result returned from graphql query: #{sawyerResourceToString(query_results)}"
        end
        results = store_commits_in_database(commits)
        final_results = combine_results(final_results,results)
      end

      "Job Complete; Retrieved #{final_results["total_commits"]} commits for Course #{@course.name} for Repo #{@github_repo.name}. Stored #{final_results["total_new_commits"]} new commits, Updated #{final_results["total_updated_commits"]} existing commits in database."
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
     result_hash(commits.length,total_new_commits,total_updated_commits)
    end

    def store_one_commit_in_database(c)
    
      commit = RepoCommitEvent.new
      begin
        commit.files_changed = c[:node][:changedFiles]
        commit.message = c[:node][:message]
        commit.commit_hash =  c[:node][:oid]
        commit.url =  c[:node][:url]
        commit.commit_timestamp =  c[:node][:author][:date]
        commit.github_repo = @github_repo
        commit.branch = "master"
        commit.committed_via_web = c[:node][:committedViaWeb]
      rescue
        return 0
      end
      commit.filenames_changed = filenames_changed(commit.commit_hash)
      
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

    # Regrettably, the v4 graphql api doesn't yet support
    # getting the filenames changed.  
    # See: https://github.community/t/get-a-repositorys-commits-along-with-changed-patches-and-the-url-to-changed-files-using-graphql-v4/13585
    def filenames_changed(commit_sha)
      begin
        github_commit_object_api_v3 = github_machine_user.commit(@github_repo_full_name,commit_sha)
        result = github_commit_object_api_v3[:files].map{ |t| t[:filename]}.to_s
      rescue
        result = ""
      end
      result
    end

    def update_one_commit(commit, c)
      begin
        commit.files_changed = c[:node][:changedFiles]
        commit.message = c[:node][:message]
        commit.commit_hash =  c[:node][:oid]
        commit.url =  c[:node][:url]
        commit.commit_timestamp =  c[:node][:author][:date]
        commit.github_repo = @github_repo
        commit.branch = "master"
        commit.committed_via_web = c[:node][:committedViaWeb]
      rescue
        return 0
      end

      commit.filenames_changed = filenames_changed(commit.commit_hash)

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

    def perform_graphql_query(repo_name, org_name, after="")
      graphql_query_string = graphql_query(repo_name, org_name, after)
      github_machine_user.post '/graphql', { query: graphql_query_string }.to_json
    end

    def graphql_query(repo_name, org_name, after)
        if after != ""
          after_clause=", after: \"#{after}\""
        else
          after_clause = ""  
        end
        # Although the published limit on Graphql queries is 100,
        # in practice, we've found that it sometimes fails.
        # 50 seems to be safer round number.
        <<-GRAPHQL
        query { 
            repository(name: "#{repo_name}", owner: "#{org_name}") {
              ref(qualifiedName: "master") {
                target {
                  ... on Commit {
                    id
                    history(first: 50 #{after_clause}) {
                      pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                      }
                      edges {
                        node {
                          committedViaWeb
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

    def sawyerResourceToJson(sawyer_resource)
      sawyer_resource.map(&:to_h).to_json
    end
end
  