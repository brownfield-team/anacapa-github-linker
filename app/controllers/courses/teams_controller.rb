require 'Octokit_Wrapper'

module Courses
  class TeamsController < ApplicationController
    before_action :load_parent
    load_and_authorize_resource :course

    def index
      @teams = @parent.org_teams
    end

    private
      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end
end