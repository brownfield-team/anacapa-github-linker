require 'Octokit_Wrapper'

module Courses
  class TeamsController < ApplicationController
    before_action :load_parent
    load_and_authorize_resource :course

    def index
      @teams = @parent.org_teams
    end

    def create_repos
      authorize! :create_repos, @course
    end

    def generate_repos
      team_name_pattern = params[:team_pattern]
      repo_name_pattern = params[:repo_pattern]
      permission_level = params[:permission]
      unless repo_name_pattern.include?("{team}")
        redirect_to course_teams_path(@course), alert: "Your naming pattern must include {team} in it."
      end
      matching_teams = OrgTeam.where(course_id: params[:course_id]).where("name ~* ?", team_name_pattern)

      repo_creation_info = []
      matching_teams.each do |team|
        repo_name = repo_name_pattern.sub("{team}", team.slug)
        repo_creation_info << { :name => repo_name, :team_id => team.team_id, :permission => permission_level }
      end
      binding.pry
      redirect_to course_teams_path(@course), notice: "Repository creation successfully queued."
    end

    private
      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end
end