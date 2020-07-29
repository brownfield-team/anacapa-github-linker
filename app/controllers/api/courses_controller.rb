module Api
  class CoursesController < ApplicationController
    respond_to :json
    load_and_authorize_resource
    include Response

    def graphql
      @course = Course.find(params[:course_id])
      query = params[:query]
      accept = params[:accept]
      results = perform_graphql_query(query,accept)
      json_response(results.to_hash)
    end
  
    private


    def perform_graphql_query(graphql_query_string, accept)
      data = {
          :query => graphql_query_string, 
      }.to_json
      options = accept ?  {
          :headers => {
          :accept => Octokit::Preview::PREVIEW_TYPES[:project_card_events]
          }
        } : {}
      github_machine_user.send :request, :post, '/graphql', data,options
    end

    def github_machine_user
      Octokit_Wrapper::Octokit_Wrapper.machine_user
    end

  end
end
