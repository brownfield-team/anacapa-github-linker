require 'json'
class CourseGithubRepoGetIssues < CourseGithubRepoJob

    @job_name = "Get Issues for this Repo"
    @job_short_name = "course_github_repo_get_issues"
    @job_description = "Get issues for this repo"
    @github_repo_full_name

    def result_hash(total, new_count, updated_count) 
      { 
        "total_issues" => total,
        "total_new_issues" => new_count,
        "total_updated_issues" => updated_count
      }
    end

    def combine_results(h1,h2) 
      {
        "total_issues" => h1["total_issues"] + h2["total_issues"],
        "total_new_issues" => h1["total_new_issues"] + h2["total_new_issues"],
        "total_updated_issues" => h1["total_updated_issues"] + h2["total_updated_issues"]
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
          more_pages = query_results[:data][:repository][:issues][:pageInfo][:hasNextPage]
          end_cursor = query_results[:data][:repository][:issues][:pageInfo][:endCursor]
          issues = query_results[:data][:repository][:issues][:nodes]
        rescue
          return "Unexpected result returned from graphql query: #{sawyerResourceToString(query_results)}"
        end
        results = store_issues_in_database(issues)
        final_results = combine_results(final_results,results)
      end

      "Job Complete; Retrieved #{final_results["total_issues"]} issues for Course #{@course.name} for Repo #{@github_repo.name}. Stored #{final_results["total_new_issues"]} new issues, Updated #{final_results["total_updated_issues"]} existing issues in database."
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
     result_hash(issues.length,total_new_issues,total_updated_issues)
    end

    def store_one_issue_in_database(i)
    
      issue = RepoIssueEvent.new
      begin
        issue.url =  i[:url]
        issue.github_repo = @github_repo
      rescue
        puts "***ERROR*** store_one_issue_in_database issue #{i} @github_repo #{@github_repo}"
        return 0
      end
      
      begin  # "try" block
        username = i[:author][:login]
        issue.roster_student = lookup_roster_student_by_github_uid(uid)
      rescue # optionally: `rescue Exception => ex`
        username = ""
        issue.roster_student = nil
      end 
      begin
        issue.save!
        return 1
      rescue
        puts "***ERROR*** on issue.save! store_one_issue_in_database issue #{i} @github_repo #{@github_repo}"
        return 0
      end
    end

   
    def update_one_issue(issue, i)
      begin
        issue.url =  i[:url]
        issue.github_repo = @github_repo
      rescue
        puts "***ERROR*** update_one_issue issue #{i} @github_repo #{@github_repo}"
        return 0
      end


      begin  # "try" block
        username = i[:author][:login]
        issue.roster_student = lookup_roster_student_by_github_username(username)
      rescue # optionally: `rescue Exception => ex`
        username = ""
        issue.roster_student = nil
      end 
      begin
        issue.save!
        return 1
      rescue
        puts "***ERROR*** on issue.save! update_one_issue issue #{i} @github_repo #{@github_repo}"
        return 0
      end
    end

    def lookup_roster_student_by_github_username(username)
        @course.student_for_github_username(username)
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
                  closed
                  closedAt
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

    def sawyerResourceToJson(sawyer_resource)
      sawyer_resource.map(&:to_h).to_json
    end
end
  