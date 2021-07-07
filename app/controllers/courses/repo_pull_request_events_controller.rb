module Courses
  class RepoPullRequestEventsController < ApplicationController
      before_action :load_parent
      load_and_authorize_resource :github_repo, through: :course
      load_and_authorize_resource :repo_pull_request_event, through: :github_repo

      def index      
          respond_to do |format|
            format.csv { send_data @github_repo.export_pull_requests_to_csv, filename: "#{@github_repo.name}-pull-requests-#{Date.today}.csv" }
          end
        end
    
      def load_parent
          @github_repo = GithubRepo.find(params[:github_repo_id])
      end
  end
end

