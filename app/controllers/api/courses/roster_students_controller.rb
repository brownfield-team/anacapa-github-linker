module Api::Courses
  class RosterStudentsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    before_action :load_student

    def index
      respond_with @course.roster_students
    end

    def show
      respond_with @roster_student
    end

    def commits
      binding.pry
      respond_with @roster_student.repo_commit_events
    end

    private
    def load_student
      @roster_student = RosterStudent.find(params[:roster_student_id])
    end
  end
end