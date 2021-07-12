module Api
  class JobLogController < ApplicationController
    respond_to :json
    
    def index
      joblog = CompletedJob.last_ten_jobs(params[:course_id],params[:github_repo_id])
      render json: joblog
    end
  end
end