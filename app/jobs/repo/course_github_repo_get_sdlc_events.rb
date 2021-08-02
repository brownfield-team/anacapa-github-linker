require 'json'

class CourseGithubRepoGetSDLCEvents < CourseGithubRepoJob

    @job_name = "Get SDLC Events for this Repo"
    @job_short_name = "course_github_repo_get_sdlc_events"
    @job_description = "Get SDLC Events for this repo"
    @github_repo_full_name

    def attempt_job(options)
      issue_outcome = retrieve_and_update_issue_sdlc_events
      pr_outcome = retrieve_and_update_pr_sdlc_events
      "SDLC Events for issues: #{issue_outcome} PRs: #{pr_outcome}"
    end

    def retrieve_and_update_issue_sdlc_events
      @github_repo_full_name = @github_repo.full_name
      final_results = JobResult.new(0,0,0)
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_issue_sdlc_events_graphql_query(@github_repo.name,@github_repo.organization,end_cursor)
        begin
          more_pages = query_results[:data][:repository][:issues][:pageInfo][:hasNextPage]
          end_cursor = query_results[:data][:repository][:issues][:pageInfo][:endCursor]
          sdlc_events = query_results[:data][:repository][:issues][:nodes]
        rescue
          return "Unexpected result returned from issue sdlc graphql query: <pre>#{sawyer_resource_to_s(query_results)}</pre>"
        end
        results = store_issue_sdlc_events_in_database(sdlc_events)
        final_results = final_results + results
        puts("\n\n\nGetting issues SDLC Events...")
        puts("#{final_results.to_s}")
        puts("Getting issues SDLC Events...#{sawyer_resource_to_s(query_results)}\n\n\n")
      end

      "Issue SDLC Events retrieved for Course: #{@course.name} Repo: #{@github_repo.name}<br>        #{final_results.report}"
    end

    def retrieve_and_update_pr_sdlc_events
      @github_repo_full_name = @github_repo.full_name
      final_results = JobResult.new(0,0,0)
      more_pages = true
      end_cursor = ""
      while more_pages
        query_results = perform_pr_sdlc_events_graphql_query(@github_repo.name,@github_repo.organization,end_cursor)
        begin
          pageInfo = query_results&.data&.repository&.pullRequests&.pageInfo
          more_pages = pageInfo&.hasNextPage
          end_cursor = pageInfo&.endCursor
          sdlc_events = query_results&.data&.repository&.pullRequests&.nodes
        rescue
          return "Unexpected result returned from issue sdlc graphql query: <pre>#{sawyer_resource_to_s(query_results)}</pre>"
        end
        results = store_pr_sdlc_events_in_database(sdlc_events)
        final_results = final_results + results
        puts("\n\n\nGetting Pull Request SDLC Events...")
        puts("#{final_results.to_s}")
        puts("Getting Pull Request SDLC Events...#{sawyer_resource_to_s(query_results)}\n\n\n")
      end

      "Pull Request SDLC Events retrieved for Course: #{@course.name} Repo: #{@github_repo.name}<br>        #{final_results.report}"
    end

    def store_issue_sdlc_events_in_database(sdlc_events)
      created = 0
      updated = 0
      sdlc_events.each{ |e|
        puts("**** WE HAVE ISSUE SDLC EVENTS #{sawyer_resource_to_s(e)}")
        # existing_sdlc_event = RepoSDLCEvent.where(url: i[:url]).first
        # if existing_sdlc_event
        #   updated += update_one_sdlc_event(existing_sdlc_event, i)
        # else
        #   created += store_one_sdlc_event_in_database(i)
        # end
      }
     JobResult.new(sdlc_events.length,created,updated,0)
    end

    def store_pr_sdlc_events_in_database(sdlc_events)
      created = 0
      updated = 0
      sdlc_events.each{ |e|
        puts("**** WE HAVE PR SDLC EVENTS #{sawyer_resource_to_s(e)}")
        # existing_sdlc_event = RepoSDLCEvent.where(url: i[:url]).first
        # if existing_sdlc_event
        #   updated += update_one_sdlc_event(existing_sdlc_event, i)
        # else
        #   created += store_one_sdlc_event_in_database(i)
        # end
      }
     JobResult.new(sdlc_events.length,created,updated,0)
    end


    def store_one_issue_sdlc_event_in_database(e)
      # TODO: create new database object
      # issue_sdlc_event = RepoIssueSdlcEvent.new
      # result = update_one_issue_sdlc_event(issue_sdlc_event,e)
    end

    def update_one_issue_sdlc_event(issue_sdlc_event, e)
      # TODO update db object ssue_sdlc_event with data from e
    end

    def store_one_pr_sdlc_event_in_database(e)
      # TODO: create new database object
      # pr_sdlc_event = RepoPrSdlcEvent.new
      # result = update_one_pr_sdlc_event(pr_sdlc_event,e)
    end

    def update_one_pr_sdlc_event(pr_sdlc_event, e)
      # TODO update db object pr_sdlc_event with data from e
    end

    def lookup_roster_student_by_github_username(username)
        @course.student_for_github_username(username)
    end

    def perform_issue_sdlc_events_graphql_query(repo_name, org_name, after="")
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

    def perform_pr_sdlc_events_graphql_query(repo_name, org_name, after="")
      # graphql_query_string = graphql_query_issue_events(repo_name, org_name, after).gsub("\n","")
      graphql_query_string = graphql_query_pr_events(repo_name, org_name, after).gsub("\n","")
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


    def graphql_query_pr_events(repo_name, org_name, after)
      if after != ""
        after_clause=", after: \"#{after}\""
      else
        after_clause = ""
      end

      # Add timeline events from : https://docs.github.com/en/graphql/reference/unions#pullrequesttimelineitems
      # Add other from here: https://docs.github.com/en/graphql/reference/objects#pullrequest
      # Including possibly: ReviewRequest, Reviews, UserEdits, Comments, etc.

      <<-GRAPHQL
      query {
        repository(owner: "#{org_name}", name: "#{repo_name}") {
          pullRequests(first: 50 #{after_clause}) {
            pageInfo {
                startCursor
                hasNextPage
                endCursor
            }
            totalCount
            nodes {
              number
              title
              body
              changedFiles
              closed
              closedAt
              createdAt
              additions
              deletions
              merged
              mergedAt
              mergedBy {
                login
                ... on User {
                  databaseId
                  email
                  name
                }
              }
              author {
                login
                ... on User {
                  databaseId
                  email
                  name
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
