require 'json'
class CourseGithubRepoGetPullRequests < CourseGithubRepoJob

    @job_name = "Get Pull Requests for this Repo"
    @job_short_name = "course_github_repo_get_pull_requests"
    @job_description = "Get pull requests for this repo"
    @github_repo_full_name

    def attempt_job(options)
      @github_repo_full_name = @github_repo.full_name
      final_results = JobResult.new
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_graphql_query(@github_repo.name, @github_repo.organization, end_cursor)
        begin
          more_pages = query_results[:data][:repository][:pullRequests][:pageInfo][:hasNextPage]
          end_cursor = query_results[:data][:repository][:pullRequests][:pageInfo][:endCursor]
          pullRequests = query_results[:data][:repository][:pullRequests][:nodes]
        rescue
          return "Unexpected result returned from graphql query: #{sawyer_resource_to_s(query_results)}"
        end
        #TODO Store in a new pull requests' table
        results = store_pull_requests_in_database(pullRequests)
        final_results = final_results + results
      end
      "Pull Requests retrieved for Course: #{@course.name} Repo: #{@github_repo.name} <br/>      #{final_results.report}"
    end

    def store_pull_requests_in_database(pullRequests)
      total_new_pull_requests = 0
      total_updated_pull_requests = 0
      #TODO UPDATE PULL REQUESTS'S TABLE
      pullRequests.each{ |i|
        existing_pull_request = RepoPullRequestEvent.where(url: i[:url]).first
        if existing_pull_request
          total_updated_pull_requests += update_one_pull_request(existing_pull_request, i)
        else
          total_new_pull_requests += store_one_pull_request_in_database(i)
        end
      }
    JobResult.new(pullRequests.length,total_new_pull_requests,total_updated_pull_requests,0)
    end

    def store_one_pull_request_in_database(i)
      pullRequest = RepoPullRequestEvent.new
      result = update_one_pull_request(pullRequest,i)
    end

    def column_name(x)
      begin
        x[:column][:name]
      rescue
        ""
      end
    end

    def column_project_name(x)
      begin
        x[:column][:project][:name]
      rescue
        ""
      end
    end

    def column_project_url(x)
      begin
        x[:column][:project][:url]
      rescue
        ""
      end
    end

    def assignee_names(x)
      begin
        x[:assignees][:nodes].map{ |node|
          node[:name] || ""
        }
      rescue
        nil
      end
    end

    def assignee_logins(x)
      begin
        x[:assignees][:nodes].map{ |node|
          node[:login] || ""
        }
      rescue
        nil
      end
    end

    def update_one_pull_request(pullRequest, i)
      begin
        pullRequest.url =  i[:url]
        pullRequest.pr_id = i[:id]
        pullRequest.github_repo = @github_repo
        pullRequest.title = i[:title]
        pullRequest.body = i[:body]
        pullRequest.state = i[:state]
        pullRequest.changedFiles = i[:changedFiles]
        pullRequest.reviewDecision = i[:reviewDecision]
        pullRequest.closed = i[:closed]
        pullRequest.closed_at = i[:closedAt]
        pullRequest.merged_at = i[:mergedAt]
        pullRequest.merged = i[:merged]
        pullRequest.pull_request_created_at = i[:createdAt]
        pullRequest.assignee_count = i[:assignees][:totalCount]
        pullRequest.assignee_names = assignee_names(i)
        pullRequest.assignee_logins = assignee_logins(i)
        pullRequest.project_card_count = i[:projectCards][:totalCount]
        pullRequest.project_card_column_names=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_name(x)})
        pullRequest.project_card_column_project_names=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_project_name(x)})
        pullRequest.project_card_column_project_urls=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_project_url(x)})
      rescue
        raise
        puts "***ERROR*** update_pull_request_fields PR #{sawyer_resource_to_s(i)} @github_repo #{@github_repo}"
        return 0
      end

      begin  # "try" block
        username = i[:author][:login]
        pullRequest.author_login = username
        pullRequest.roster_student = lookup_roster_student_by_github_username(username)
      rescue # optionally: `rescue Exception => ex`
        username = ""
        pullRequest.roster_student = nil
      end

      begin
        pullRequest.save!
        return 1
      rescue
        puts "***ERROR*** on pullRequest.save! pullRequest #{i} @github_repo #{@github_repo}"
        return 0
      end
    end

    def lookup_roster_student_by_github_username(username)
        @course.student_for_github_username(username)
    end

    def array_or_singleton_to_s(a)
      return nil if a.nil? or a.length==0
      return a.first.to_s if a.length==1
      a.sort.to_s
    end

    def perform_graphql_query(repo_name, org_name, after="")
      graphql_query_string = graphql_query(repo_name, org_name, after)
      options = { query: graphql_query_string }.to_json
      github_machine_user.post '/graphql', options
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

        # TODO: Add closed and closedAt to database
        # TODO: Get body, and parse for checkboxes, complete and incomplete
        # TODO: Add number of assignees, and try to tie assignees back to
        #   roster students if possible.
        
        <<-GRAPHQL
        {
          repository(name: "#{repo_name}", owner: "#{org_name}") {
            pullRequests(first: 50 #{after_clause}) {
              pageInfo {
                startCursor
                hasNextPage
                endCursor
              }
              nodes {
                projectCards(first: 50) {
                  totalCount
                  nodes {
                    column {
                      name
                      project {
                        name
                        url
                        number
                      }
                    }
                  }
                }
                assignees(first: 50) {
                  pageInfo {
                    startCursor
                    hasNextPage
                    endCursor
                  }
                  totalCount
                  nodes {
                    id
                    login
                    name
                  }
                }
                id
                closed
                closedAt
                createdAt
                mergedAt
                merged
                url
                number
                title
                body
                author {
                  login
                }
                databaseId
                milestone {
                  id
                }
                state
                changedFiles
                reviewDecision
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
