module Api::Courses
    class AssignmentsController < ApplicationController
      respond_to :json
      load_and_authorize_resource :course
      load_and_authorize_resource
  
      def index
        respond_with @course.assignments
      end
  
      def show
        respond_with @assignment
      end
  
      def create
        respond_with :api, @course, Assignment.create(assignment_params)
      end
  
      def destroy
        respond_with Assignment.destroy(params[:id])
      end
  
      def update
        project_team = Assignment.find(params[:id])
        project_team.update_attributes(assignment_params)
        respond_with assignment, json: assignment
      end
  
      private
  
      def assignment_params
        params.require(:assignment).permit(:name, :course_id)
      end
  
    end
  end
  