module Api::Courses
  class OrgTeamsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
      respond_with @course.org_teams
    end

    def show
      members = @org_team.student_team_memberships.map{ |s| { 
          membership: s, 
          full_name: s.roster_student.full_name, 
          github_id: s.roster_student.user.username 
        } 
      }
      response = { org_team: @org_team, members: members, course: @course }
      respond_with response
    end
  end
end
