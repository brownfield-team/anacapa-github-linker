module Courses
  class ProjectTeamsController < ApplicationController
    before_action :load_parent
    load_and_authorize_resource :course

    def index
      @teams = @parent.project_teams
      respond_to do |format|
        format.html do
        end
        format.json do
          render json: @teams
        end
      end
    end

    private

    def load_parent
      @parent = Course.find(params[:course_id])
    end
  end
end