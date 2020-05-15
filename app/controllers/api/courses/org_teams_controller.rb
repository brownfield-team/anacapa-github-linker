module Api::Courses
  class OrgTeamsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
      respond_with @course.org_teams
    end

    def show
      respond_with @org_team
    end
  end
end
