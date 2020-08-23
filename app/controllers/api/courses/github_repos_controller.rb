module Api::Courses
  class GithubReposController < ApplicationController
    respond_to :json
    load_and_authorize_resource :course
    load_and_authorize_resource

    def index
        @github_repos = @course.github_repos.all
        search_query = params[:search]
        visibility_query = params[:visibility]
        unless search_query.nil? || search_query.empty?
          @github_repos = @github_repos.where("name LIKE ?", "%#{search_query}%")
        end
        unless visibility_query.nil? || visibility_query.empty?
          @github_repos = @github_repos.where(visibility: visibility_query)
        end
        paginate json: @github_repos
    end

    def show
      respond_with @github_repo
    end
  end
end
