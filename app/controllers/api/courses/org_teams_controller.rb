module Api::Courses
  class OrgTeamsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
      respond_with @course.org_teams
    end

    def update
      @org_team = OrgTeam.find(params[:id])
      @org_team.update_attributes(org_team_params)
      @org_team.save
    end

    def org_team_params
      params.require(:org_team).permit(:id, :name, :url, :course_id, :created_at, :updated_at, :team_id, :slug, :project_repo_id)
    end

    def show
      members = @org_team.student_team_memberships.map{ |s| { 
          membership: s, 
          full_name: s.roster_student.full_name, 
          github_id: s.roster_student.user.username 
        } 
      }

      repos = @org_team.repo_team_contributors.map{ |r| {
          repo: r,
          repo_name: r.github_repo.name,
          permission: r.permission_level
        }
      }

      response = { org_team: @org_team, members: members, course: @course, repos: repos }
      respond_with response
    end
  end
end
