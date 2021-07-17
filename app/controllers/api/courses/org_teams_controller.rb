module Api::Courses
  class OrgTeamsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course

    def index
      response = { course: @course }
      respond_with response
    end

  end
end
