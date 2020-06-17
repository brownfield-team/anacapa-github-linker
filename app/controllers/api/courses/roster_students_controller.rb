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

    def activity
      start_date = Date.parse(params[:start_date]) || Date.today - 30
      end_date = Date.parse(params[:end_date]) || Date.today
      respond_with @roster_student.activity_stream(start_date, end_date)
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