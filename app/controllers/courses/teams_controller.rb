require 'Octokit_Wrapper'

module Courses
  class TeamsController < ApplicationController
    before_action :load_parent
    load_and_authorize_resource :course

    def show
      @teams = @parent.org_teams
    end

    def create_repos

    end

    def generate_repos
      team_name_pattern = params[:team_pattern]
      repo_name_pattern = params[:repo_pattern]
      permission_level = params[:permission]
      visibility = params[:visibility]
      unless repo_name_pattern.include?("{team}")
        redirect_to course_teams_path(@course), alert: "Your naming pattern must include {team} in it."
      end
      options = { :team_pattern => team_name_pattern, :repo_pattern => repo_name_pattern, :permission_level => permission_level, :visibility => visibility }
      CreateTeamReposJob.perform_async(@parent.id, options)
      redirect_to course_teams_path(@course), notice: "Repository creation successfully queued."
    end

    def create_teams

    end

    private
      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end
end