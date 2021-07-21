module Api::Courses
  class RosterStudentsController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    before_action :load_student, except: [:index]

    def index
      respond_with @course.roster_students
    end

    def show
      respond_with @roster_student
    end

    def activity
      # This can be significantly optimized if it ever needs to be by converting it entirely into a single SQL query.
      # Just not worth the effort right now.
      start_date = Date.parse(params[:start_date]) || Date.today - 30
      end_date = Date.parse(params[:end_date]) || Date.today
      activity = []
      activity += @roster_student.repo_commit_events
      activity += @roster_student.repo_issue_events
      activity += @roster_student.repo_pull_request_events
      sorted_and_filtered_activity = activity.select { |a| a.created_at > start_date && a.created_at < end_date }.sort_by(&:created_at)
      respond_with sorted_and_filtered_activity
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