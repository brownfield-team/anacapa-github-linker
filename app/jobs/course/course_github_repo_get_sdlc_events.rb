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

    def all_good?(result_hash)
      result_hash["total_sdlc_events"]==result_hash["total_new_sdlc_events"] + result_hash["total_updated_sdlc_events"]
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
          return "Unexpected result returned from graphql query: <pre>#{sawyer_resource_to_s(query_results)}</pre>"
        end
        results = store_sdlc_events_in_database(sdlc_events)
        final_results = combine_results(final_results,results)
      end

      "Job Complete; Retrieved #{final_results["total_sdlc_events"]} sdlc_events for Course #{@course.name} for Repo #{@github_repo.name}. Stored #{final_results["total_new_sdlc_events"]} new sdlc_events, Updated #{final_results["total_updated_sdlc_events"]} existing sdlc_events in database."
    end  

    def store_sdlc_events_in_database(sdlc_events)
      total_new_sdlc_events = 0
      total_updated_sdlc_events = 0
      sdlc_events.each{ |e|
        puts("**** WE HAVE AN SDLC EVENT #{sawyer_resource_to_s(e)}")
        # existing_sdlc_event = RepoSDLCEvent.where(url: i[:url]).first
        # if existing_sdlc_event
        #   total_updated_sdlc_events += update_one_sdlc_event(existing_sdlc_event, i)
        # else
        #   total_new_sdlc_events += store_one_sdlc_event_in_database(i) 
        # end
      }
     result_hash(sdlc_events.length,total_new_sdlc_events,total_updated_sdlc_events)
    end

    def store_one_sdlc_event_in_database(e)
    #   sdlc_event = RepoSDLCEvent.new
    #   result = update_one_sdlc_event(sdlc_event,e)
    end

    def update_one_sdlc_event(sdlc_event, e)
      
    #   begin
    #     sdlc_event.url =  e[:url]
    #     sdlc_event.github_repo = @github_repo
    #     sdlc_event.title = e[:title]
    #   rescue
    #     puts "***ERROR*** update_sdlc_fields sdlc_event #{i} @github_repo #{@github_repo}"
    #     return 0
    #   end
      
    #   begin  # "try" block
    #     username = e[:author][:login]
    #     sdlc_event.roster_student = lookup_roster_student_by_github_uid(uid)
    #   rescue # optionally: `rescue Exception => ex`
    #     username = ""
    #     sdlc_event.roster_student = nil
    #   end 

    #   begin
    #     sdlc_event.save!
    #     return 1
    #   rescue
    #     puts "***ERROR*** on sdlc_event.save! sdlc #{sawyer_resource_to_s(e)} @github_repo #{@github_repo}"
    #     return 0
    #   end
    end

    def lookup_roster_student_by_github_username(username)
        @course.student_for_github_username(username)
    end

    def perform_graphql_query(repo_name, org_name, after="")
      graphql_query_string = graphql_query_issue_events(repo_name, org_name, after).gsub("\n","")
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

    def graphql_query_issue_events(repo_name, org_name, after)
        if after != ""
          after_clause=", after: \"#{after}\""
        else
          after_clause = ""  
        end
       
        # LIST OF EVENTS: https://docs.github.com/en/graphql/reference/unions#issuetimelineitems
        
        <<-GRAPHQL
        query {
            repository(owner: "#{org_name}", name: "#{repo_name}") {
              issues(first: 50 #{after_clause}) {
                pageInfo {
                    startCursor
                    hasNextPage
                    endCursor
                }
                nodes {
                  number
                  url
                  title
                  createdAt
                  state
                  author {
                    login
                    ... on User {
                      databaseId
                      email
                      name
                    }
                  }
                  userContentEdits(first: 50) {
                    pageInfo {
                      startCursor
                      hasNextPage
                      endCursor
                    }
                    nodes {
                      createdAt
                      deletedAt
                      deletedBy {
                        login
                        ... on User {
                          databaseId
                          email
                          name
                        }
                      }
                      editedAt
                      editor {
                        login
                        ... on User {
                          databaseId
                          email
                          name
                        }
                      }
                      updatedAt
                      diff
                    }
                  }
                  timelineItems(itemTypes: [ADDED_TO_PROJECT_EVENT, ASSIGNED_EVENT,  CLOSED_EVENT, MOVED_COLUMNS_IN_PROJECT_EVENT, REMOVED_FROM_PROJECT_EVENT, REOPENED_EVENT], first: 50) {
                    pageInfo {
                      startCursor
                      hasNextPage
                      endCursor
                    }
                    nodes {
                      __typename
                      ... on AddedToProjectEvent {
                        id
                        actor {
                          login
                          ... on User {
                            databaseId
                            email
                            name
                          }
                        }
                        createdAt
                        project {
                            name
                            url
                        }
                        projectColumnName
                      }
                      ... on AssignedEvent {
                        id
                        createdAt
                        actor {
                          login
                          ... on User {
                            databaseId
                            email
                            name
                          }
                        }
                        assignee {
                          ... on User {
                            login
                            databaseId
                            email
                            name
                          }
                        }

                      }
                      ... on ClosedEvent {
                        id
                        actor {
                          login
                          ... on User {
                            databaseId
                            email
                            name
                          }
                        }
                        closer {
                          __typename
                          ... on Commit {
                            url
                            oid
                            message
                          }
                          ... on PullRequest {
                            title
                            url
                          }
                        }
                        createdAt
                        url
                      }
                      ... on MovedColumnsInProjectEvent {
                        id
                        actor {
                          login
                          ... on User {
                            databaseId
                            email
                            name
                          }
                        }
                        createdAt
                        project {
                          name
                          url
                        }
                        previousProjectColumnName
                        projectColumnName
                      }
                      ... on RemovedFromProjectEvent {
                        id
                        actor {
                          login
                          ... on User {
                            databaseId
                            email
                            name
                          }
                        }
                        createdAt
                        project {
                          name
                          url
                        }
                        projectColumnName
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
        result = JSON.pretty_generate(sawyer_resource.to_hash)
      rescue
        result = sawyer_resource.to_s 
      end
      result
    end

end
  