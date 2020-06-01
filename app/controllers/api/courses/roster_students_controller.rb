class RosterStudentsController < ApplicationController
  respond_to :json
  load_and_authorize_resource :course
  load_and_authorize_resource

  def commits
    respond_with @roster_student.github_repo_commits
  end
end