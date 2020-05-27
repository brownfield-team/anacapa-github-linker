module Courses
  class SlackController < ApplicationController
    layout 'courses'
    load_and_authorize_resource :course

    def show
      @slack_workspace = @course.slack_workspace
    end

    def destroy
      @course = Course.find(params[:course_id])
      if @course.slack_workspace.present?
        @course.slack_workspace.destroy
        @course.save
        redirect_to course_slack_path(@course), notice: "Workspace successfully removed from course."
      else
        redirect_to course_slack_path(@course), alert: "Workspace to delete could not be found."
      end
    end
  end
end