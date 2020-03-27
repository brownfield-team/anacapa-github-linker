module Courses
  class SlackController < ApplicationController
    def show
      @parent = Course.find(params[:course_id])
      @workspace = @parent.slack_workspace
    end

    def destroy
      @parent = Course.find(params[:course_id])
      if @parent.slack_workspace.present?
        @parent.slack_workspace.destroy
        @parent.save
        redirect_to course_slack_path(@parent), notice: "Workspace successfully removed from course."
      else
        redirect_to course_slack_path(@parent), alert: "Workspace to delete could not be found."
      end
    end
  end
end