require 'Octokit_Wrapper'

module Courses
  class OrgTeamsController < ApplicationController
    before_action :load_parent
    load_and_authorize_resource :course
    layout 'courses'

    def index
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
        redirect_to create_teams_course_org_teams_path(@course), alert: "Your naming pattern must include {team} in it."
      end
      options = {:team_pattern => team_name_pattern, :repo_pattern => repo_name_pattern, :permission_level => permission_level, :visibility => visibility}
      CreateTeamReposJob.perform_async(@parent.id, options)
      redirect_to course_org_teams_path(@course), notice: "Repository creation successfully queued."
    end

    def create_teams

    end

    def generate_teams
      team_csv = params[:file]
      team_hash = Hash.new
      ignore_first_row = params[:ignore_first_row]
      CSV.foreach(team_csv.path) do |row|
        if ignore_first_row.present? && ignore_first_row != 0
          ignore_first_row = 0
          next
        end
        team_name = row[1].strip
        team_hash[team_name] ||= []
        team_hash[team_name] << row[0].strip
      end
      CreateGithubTeamsJob.perform_async(@course.id, {:teams => team_hash})
      redirect_to course_org_teams_path(@course), notice: "Team creation successfully queued."
    end

    private

    def load_parent
      @parent = Course.find(params[:course_id])
    end
  end
end