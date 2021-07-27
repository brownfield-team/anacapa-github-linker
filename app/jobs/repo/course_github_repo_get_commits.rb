require 'json'
class CourseGithubRepoGetCommits < CourseGithubRepoJob

    @job_name = "Get Commits for this Repo"
    @job_short_name = "course_github_repo_get_commits"
    @job_description = "Get commits for this repo"
    @github_repo_full_name

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

    def set_package_lock_json_fields_to_zero(commit)
      commit.package_lock_json_files_changed = 0
      commit.package_lock_json_additions = 0
      commit.package_lock_json_deletions = 0
    end

    # Regrettably, the v4 graphql api doesn't yet support
    # getting the filenames changed.
    # See: https://github.community/t/get-a-repositorys-commits-along-with-changed-patches-and-the-url-to-changed-files-using-graphql-v4/13585
    def update_from_restapi(commit)
      commit_sha = commit.commit_hash
      # Rails.logger.info "commit_object=#{sawyer_resource_to_s(github_commit_object_api_v3)}"

      begin
        github_commit_object_api_v3 = github_machine_user.commit(@github_repo_full_name,commit_sha)
      rescue
        commit.filenames_changed = "ERROR1"
        set_package_lock_json_fields_to_zero(commit)
        return
      end
      
      begin
        array_of_files_changed = github_commit_object_api_v3[:files].map{ |t| t[:filename]}
        commit.filenames_changed = array_of_files_changed.to_s
        commit.package_lock_json_files_changed = array_of_files_changed.count{ |s| s.include?("package-lock.json") }
      rescue
        commit.filenames_changed = "ERROR2"
        set_package_lock_json_fields_to_zero(commit)
        return
      end

      if commit.package_lock_json_files_changed > 0
        change = github_commit_object_api_v3[:files].select{ |t| t[:filename].include?("package-lock.json") }
        commit.package_lock_json_additions = change.inject(0) {|sum, hash| sum + hash[:additions]}
        commit.package_lock_json_deletions = change.inject(0) {|sum, hash| sum + hash[:deletions]}
      else
        set_package_lock_json_fields_to_zero(commit)
      end

    end

    # Here is an example of the JSON returned for the :files object
    #
    # :files=>[
    #     {:sha=>"cdf1f12ad1878348846fd313214bd607a9ca7b5c", 
    #     :filename=>"javascript/src/main/pages/Students/EditStudent.js", 
    #     :status=>"modified", 
    #     :additions=>1, 
    #     :deletions=>1,
    #     :changes=>2, 
    #     :blob_url=>"https://github.com/ucsb-cs156-s21/proj-mapache-search/blob/0438aa5cc7b6d96dbb0ee380a62e69a0abf05b98/javascript/src/main/pages/Students/EditStudent.js",
    #     :raw_url=>"https://github.com/ucsb-cs156-s21/proj-mapache-search/raw/0438aa5cc7b6d96dbb0ee380a62e69a0abf05b98/javascript/src/main/pages/Students/EditStudent.js", 
    #     :contents_url=>"https://api.github.com/repos/ucsb-cs156-s21/proj-mapache-search/contents/javascript/src/main/pages/Students/EditStudent.js?ref=0438aa5cc7b6d96dbb0ee380a62e69a0abf05b98", 
    #     :patch=>"@@ -43,4 +43,4 @@ const EditStudent = () => {\n   );\n };\n \n-export default EditStudent;\n\\ No newline at end of file\n+export default EditStudent;"
    #   }
    # ]

    def update_roster_student(commit, c, branch_name)
      begin  # "try" block
        uid = c[:node][:author][:user][:databaseId]
        commit.roster_student = lookup_roster_student_by_github_uid(uid)
        return
      rescue 
        commit.roster_student = commit.roster_student_for_commit(@course)
      end
    end

    def update_one_commit(commit, c, branch_name)
      begin
        commit.course_id = @course.id
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
        Rails.logger.error "***ERROR*** update_commit_fields commit #{sawyer_resource_to_s(c)} @github_repo #{@github_repo}"
        raise
        return 0
      end

      update_from_restapi(commit)

      update_roster_student(commit, c, branch_name)

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

    def lookup_roster_student_by_orphan_name(name)
      @course.student_for_orphan_name(name)
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
        
        if ( (@course.start_date != nil) and (@course.end_date != nil) )
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
