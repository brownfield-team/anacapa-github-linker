module Api
  class CoursesController < ApplicationController

    respond_to :json
    load_and_authorize_resource :course

    def index
      respond_with Course.all
    end

    def show
      respond_with @course
    end

  end
end
