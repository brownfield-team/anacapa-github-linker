module Api::Courses
  class GithubReposController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
      respond_with @course.github_repos
    end

    def show
      respond_with @github_repo
    end
  end
end
