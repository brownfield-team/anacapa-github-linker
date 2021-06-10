require 'json'
class CourseGithubRepoGetCommits < CourseGithubRepoJob

    @job_name = "Get Commits for this Repo"
    @job_short_name = "course_github_repo_get_commits"
    @job_description = "Get commits for this repo"
    @github_repo_full_name

    # def result_hash(total, new_count, updated_count)
    #   {
    #     "total_commits" => total,
    #     "total_new_commits" => new_count,
    #     "total_updated_commits" => updated_count
    #   }
    # end

    # def combine_results(h1,h2)
    #   {
    #     "total_commits" => h1["total_commits"] + h2["total_commits"],
    #     "total_new_commits" => h1["total_new_commits"] + h2["total_new_commits"],
    #     "total_updated_commits" => h1["total_updated_commits"] + h2["total_updated_commits"]
    #   }
    # end

    # def all_good?(result_hash)
    #   result_hash["total_commits"]==(result_hash["total_new_commits"] + result_hash["total_updated_commits"])
    # end

    def attempt_job(options)
      @github_repo_full_name = @github_repo.full_name
      final_results = JobResult.new
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_graphql_query(@github_repo.name, @github_repo.organization, end_cursor)
        begin
          default_branch_data = query_results[:data][:repository][:defaultBranchRef]
          more_pages = default_branch_data[:target][:history][:pageInfo][:hasNextPage]
          end_cursor = default_branch_data[:target][:history][:pageInfo][:endCursor]
          commits = default_branch_data[:target][:history][:edges]
          branch_name = default_branch_data[:name]
        rescue
          return "Unexpected result returned from graphql query: #{sawyer_resource_to_s(query_results)}"
        end
        results = store_commits_in_database(commits, branch_name)
        final_results = final_results + results
      end
      "Commits retrieved for Course: #{@course.name} Repo: #{@github_repo.name}<br />      #{final_results.report}"
    end

    def store_commits_in_database(commits, branch_name)
      total_new_commits = 0
      total_updated_commits = 0
      commits.each{ |c|
        existing_commit = RepoCommitEvent.find_or_initialize_by(commit_hash: c[:node][:oid])
        if existing_commit.persisted?
          total_updated_commits += update_one_commit(existing_commit, c, branch_name)
        else
          total_new_commits += update_one_commit(existing_commit, c, branch_name)
        end
      }
     JobResult.new(commits.length,total_new_commits,total_updated_commits)
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

    def update_one_commit(commit, c, branch_name)
      begin
        commit.files_changed = c[:node][:changedFiles]
        commit.additions = c[:node][:additions]
        commit.deletions = c[:node][:deletions]
        commit.message = c[:node][:message]
        commit.commit_hash =  c[:node][:oid]
        commit.url =  c[:node][:url]
        commit.commit_timestamp =  c[:node][:author][:date]
        commit.github_repo = @github_repo
        commit.branch = branch_name
        commit.committed_via_web = c[:node][:committedViaWeb]
        commit.author_login = c.node&.author&.user&.login
        commit.author_name = c.node&.author&.name
        commit.author_email = c.node&.author&.email
      rescue
        raise
        puts "***ERROR*** update_commit_fields commit #{sawyer_resource_to_s(c)} @github_repo #{@github_repo}"
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

        # if there is a start and end date for the course, use it
        # otherwise the since/until clause is empty

        since_until_clause = ""

        if ( @course.start_date != "" and @course.end_date != "")
          start_date = @course.start_date.to_time.iso8601 # convert to correct format
          end_date = @course.end_date.to_time.iso8601 # convert to correct format
          since_until_clause = ", since: \"#{start_date}\", until: \"#{end_date}\""
        end

        # Although the published limit on Graphql queries is 100,
        # in practice, we've found that it sometimes fails.
        # 50 seems to be safer round number.
        <<-GRAPHQL
        query { 
            repository(name: "#{repo_name}", owner: "#{org_name}") {
              defaultBranchRef {
                name
                target {
                  ... on Commit {
                    id
                    history(first: 50 #{after_clause} #{since_until_clause}) {
                      pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                      }
                      edges {
                        node {
                          additions
                          deletions
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

    def sawyer_resource_to_s(sawyer_resource)
      begin
        result = sawyer_resource.to_hash.to_s
      rescue
        result = sawyer_resource.to_s
      end
      result
    end
end
