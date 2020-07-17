module Api
  class CoursesController < ApplicationController
    respond_to :json
    load_and_authorize_resource

    def jobs
      course = Course.find(params[:course_id])
      jobs = course.course_job_info_list
      respond_with jobs
    end

  end
end
