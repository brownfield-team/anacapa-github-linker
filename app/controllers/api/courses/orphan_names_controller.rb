module Api::Courses
    class OrphanNamesController < ApplicationController
      respond_to :json
      load_and_authorize_resource :course
  
      def index
        respond_with @course.orphan_names
      end
  
      def commits_by_name
        paginate json: @course.orphans_by_name(params[:name])
      end

    end
  end