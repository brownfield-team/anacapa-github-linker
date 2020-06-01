class RosterStudentsController < ApplicationController
  respond_to :json
  load_and_authorize_resource :course
  load_and_authorize_resource
  
  def index
    respond_with @course.roster_students
  end

  def show
    respond_with @roster_student
  end

  def commits
    respond_with @roster_student.github_repo_commits
  end
end