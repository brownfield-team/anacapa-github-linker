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
      paginate json: @roster_student.repo_commit_events
    end

    def issues
      paginate json: @roster_student.repo_issue_events
    end

    def pull_requests
      paginate json: @roster_student.repo_pull_request_events
    end

    private
    def load_student
      @roster_student = RosterStudent.find(params[:roster_student_id])
    end
  end
end