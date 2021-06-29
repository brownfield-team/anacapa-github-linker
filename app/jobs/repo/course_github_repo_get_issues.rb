require 'json'
class CourseGithubRepoGetIssues < CourseGithubRepoJob

    @job_name = "Get Issues for this Repo"
    @job_short_name = "course_github_repo_get_issues"
    @job_description = "Get issues for this repo"
    @github_repo_full_name

    # defJobResult.newh(total, new_count, updated_count)
    #   {
    #     "total_issues" => total,
    #     "total_new_issues" => new_count,
    #     "total_updated_issues" => updated_count
    #   }
    # end

    # def combine_results(h1,h2)
    #   {
    #     "total_issues" => h1["total_issues"] + h2["total_issues"],
    #     "total_new_issues" => h1["total_new_issues"] + h2["total_new_issues"],
    #     "total_updated_issues" => h1["total_updated_issues"] + h2["total_updated_issues"]
    #   }
    # end

    # def all_good?JobResult.newh)
    #  JobResult.newh["total_issues"]=JobResult.newh["total_new_issues"] +JobResult.newh["total_updated_issues"]
    # end

    def attempt_job(options)
      @github_repo_full_name = @github_repo.full_name
      final_results = JobResult.new
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_graphql_query(@github_repo.name, @github_repo.organization, end_cursor)
        begin
          more_pages = query_results[:data][:repository][:issues][:pageInfo][:hasNextPage]
          end_cursor = query_results[:data][:repository][:issues][:pageInfo][:endCursor]
          issues = query_results[:data][:repository][:issues][:nodes]
        rescue
          return "Unexpected result returned from graphql query: #{sawyer_resource_to_s(query_results)}"
        end
        results = store_issues_in_database(issues)
        final_results = final_results + results
      end
      "Issues retrieved for Course: #{@course.name} Repo: #{@github_repo.name} <br/>      #{final_results.report}"
    end

    def store_issues_in_database(issues)
      total_new_issues = 0
      total_updated_issues = 0
      issues.each{ |i|
        existing_issue = RepoIssueEvent.where(url: i[:url]).first
        if existing_issue
          total_updated_issues += update_one_issue(existing_issue, i)
        else
          total_new_issues += store_one_issue_in_database(i)
        end
      }
    JobResult.new(issues.length,total_new_issues,total_updated_issues)
    end

    def store_one_issue_in_database(i)
      issue = RepoIssueEvent.new
      result = update_one_issue(issue,i)
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

    def update_one_issue(issue, i)
      begin
        issue.url =  i[:url]
        issue.number = i[:number]
        issue.issue_id = i[:id]
        issue.github_repo = @github_repo
        issue.title = i[:title]
        issue.body = i[:body]
        issue.state = i[:state]
        issue.closed = i[:closed]
        issue.closed_at = i[:closedAt]
        issue.issue_created_at = i[:createdAt]
        issue.assignee_count = i[:assignees][:totalCount]
        issue.assignee_names = assignee_names(i)
        issue.assignee_logins = assignee_logins(i)
        issue.project_card_count = i[:projectCards][:totalCount]
        issue.project_card_column_names=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_name(x)})
        issue.project_card_column_project_names=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_project_name(x)})
        issue.project_card_column_project_urls=array_or_singleton_to_s(i[:projectCards][:nodes].map{|x| column_project_url(x)})
      rescue
        raise
        puts "***ERROR*** update_issue_fields issue #{sawyer_resource_to_s(i)} @github_repo #{@github_repo}"
        return 0
      end

      begin  # "try" block
        username = i[:author][:login]
        issue.author_login = username
        issue.roster_student = lookup_roster_student_by_github_username(username)
      rescue # optionally: `rescue Exception => ex`
        username = ""
        issue.roster_student = nil
      end

      begin
        issue.save!
        return 1
      rescue
        puts "***ERROR*** on issue.save! issue #{i} @github_repo #{@github_repo}"
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
            issues(first: 50 #{after_clause}) {
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
