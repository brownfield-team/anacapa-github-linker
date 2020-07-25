require 'json'

class CourseGithubRepoGetSDLCEvents < CourseGithubRepoJob

    @job_name = "Get SDLC Events for this Repo"
    @job_short_name = "course_github_repo_get_sdlc_events"
    @job_description = "Get SDLC Events for this repo"
    @github_repo_full_name

    def result_hash(total, new_count, updated_count) 
      { 
        "total_sdlc_events" => total,
        "total_new_sdlc_events" => new_count,
        "total_updated_sdlc_events" => updated_count
      }
    end

    def combine_results(h1,h2) 
      {
        "total_sdlc_events" => h1["total_sdlc_events"] + h2["total_sdlc_events"],
        "total_new_sdlc_events" => h1["total_new_sdlc_events"] + h2["total_new_sdlc_events"],
        "total_updated_sdlc_events" => h1["total_updated_sdlc_events"] + h2["total_updated_sdlc_events"]
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
          sdlc_events = query_results[:data][:repository][:issues][:nodes]
        rescue
          return "Unexpected result returned from graphql query: #{sawyerResourceToString(query_results)}"
        end
        results = store_sdlc_events_in_database(sdlc_events)
        final_results = combine_results(final_results,results)
      end

      "Job Complete; Retrieved #{final_results["total_sdlc_events"]} sdlc_events for Course #{@course.name} for Repo #{@github_repo.name}. Stored #{final_results["total_new_sdlc_events"]} new sdlc_events, Updated #{final_results["total_updated_sdlc_events"]} existing sdlc_events in database."
    end  

    def store_sdlc_events_in_database(sdlc_events)
      total_new_sdlc_events = 0
      total_updated_sdlc_events = 0
      sdlc_events.each{ |i|
        puts("**** WE HAVE AN SDLC EVENT #{sawyerResourceToString(i)}")
        # existing_issue = RepoSDLCEvent.where(url: i[:url]).first
        # if existing_issue
        #   total_updated_sdlc_events += update_one_issue(existing_issue, i)
        # else
        #   total_new_sdlc_events += store_one_issue_in_database(i) 
        # end
      }
     result_hash(sdlc_events.length,total_new_sdlc_events,total_updated_sdlc_events)
    end

    def store_one_issue_in_database(i)
    #   issue = RepoIssueEvent.new
    #   result = update_one_issue(issue,i)
    end

    def update_one_issue(issue, i)
      
    #   begin
    #     issue.url =  i[:url]
    #     issue.github_repo = @github_repo
    #     issue.title = i[:title]
    #   rescue
    #     puts "***ERROR*** update_issue_fields issue #{i} @github_repo #{@github_repo}"
    #     return 0
    #   end
      
    #   begin  # "try" block
    #     username = i[:author][:login]
    #     issue.roster_student = lookup_roster_student_by_github_uid(uid)
    #   rescue # optionally: `rescue Exception => ex`
    #     username = ""
    #     issue.roster_student = nil
    #   end 

    #   begin
    #     issue.save!
    #     return 1
    #   rescue
    #     puts "***ERROR*** on issue.save! issue #{i} @github_repo #{@github_repo}"
    #     return 0
    #   end
    end

    def lookup_roster_student_by_github_username(username)
        @course.student_for_github_username(username)
    end

    def perform_graphql_query(repo_name, org_name, after="")
      graphql_query_string = graphql_query(repo_name, org_name, after).gsub("\n","")
      data = {
          :query => graphql_query_string, 
      }.to_json
      options = {
        :headers => {
        :accept => Octokit::Preview::PREVIEW_TYPES[:project_card_events]
        }
      }
      github_machine_user.send :request, :post, '/graphql', data,options
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

        # repository(name: "#{repo_name}", owner: "#{org_name}") {
        #     issues(first: 50 #{after_clause}) {

        <<-GRAPHQL
        query {
            repository(owner: "ucsb-cs48-s20", name: "project-s0-t1-budget") {
              issues(last: 100) {
                pageInfo {
                    startCursor
                    hasNextPage
                    endCursor
                }
                nodes {
                  number
                  timelineItems(itemTypes: [ADDED_TO_PROJECT_EVENT, MOVED_COLUMNS_IN_PROJECT_EVENT], first: 100) {
                    nodes {
                      __typename
                      ... on AddedToProjectEvent {
                        id
                        actor {
                          login
                        }
                        
                        project {
                            name
                        }
                       
                      }
                      ... on MovedColumnsInProjectEvent {
                        id
                        actor {
                          login
                        }
                        createdAt
                      }
                    }
                  }
                }
              }
            }
          }          
        GRAPHQL
    end

    def sawyerResourceToString(sawyer_resource)
      # result = sawyer_resource.map(&:to_h).to_json
      sawyer_resource.to_json
    end

end
  