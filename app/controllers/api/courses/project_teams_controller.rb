module Api
  module Courses
    class ProjectTeamsController < ApplicationController
      load_and_authorize_resource :course

      def index
        render json: @course.project_teams
      end
    end
  end
end