module Api::Courses
    class OrphanEmailsController < ApplicationController
      respond_to :json
      load_and_authorize_resource :course
  
      def index
        respond_with @course.orphan_emails
      end
  
      def commits_by_email
        paginate json: @course.orphans_by_email(params[:email])
      end

    end
  end