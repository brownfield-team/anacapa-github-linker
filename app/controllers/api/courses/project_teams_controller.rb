module Api::Courses
  class ProjectTeamsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
      respond_with @course.project_teams
    end

    def show
      respond_with @project_team
    end

    def create
      respond_with ProjectTeam.create(project_team_params)
    end

    def destroy
      respond_with ProjectTeam.destroy(params[:id])
    end

    def update
      project_team = ProjectTeam.find(params[:id])
      project_team.update_attributes(project_team_params)
      respond_with project_team
    end

    private

    def project_team_params
      params.require(:project_team).permit(:id, :name, :qa_url, :production_url, :team_chat_url, :meeting_time,
                                           :course_id, :github_repo_id, :org_team_id, :repo_url, :project,
                                           :milestones_url, :project_board_url)
    end

  end
end
