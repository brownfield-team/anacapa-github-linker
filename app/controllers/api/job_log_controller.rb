module Api
  class JobLogController < ApplicationController
    respond_to :json
    
    def index
      joblog = CompletedJob.last_ten_jobs(nil,nil)
      render json: joblog
    end
  end
end