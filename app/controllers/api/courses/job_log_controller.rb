module Api::Courses
  class JobLogController < ApplicationController
    respond_to :json
    
    def index
      # @course = Course.find(params[:course_id])
      #joblog = CompletedJob.last_ten_jobs(@course.id,nil)

      joblog = CompleteJob.last_ten_jobs(params[:course_id],params[:repo_id])
      render json: joblog
    end
  end
end