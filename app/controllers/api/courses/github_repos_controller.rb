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

        github_repos_array = @github_repos.to_a
        github_repos_hash_array = github_repos_array.map{ |repo| repo_to_hash(repo) }
        paginate json: github_repos_hash_array
    end

    def show
      respond_with repo_to_hash(@github_repo)
    end

    private
    def repo_to_hash(repo)
      github_repo = GithubRepo.find(repo.id)
      {
        repo: repo,
        commit_count: github_repo.repo_commit_events.count,
        issue_count: github_repo.repo_issue_events.count
      }

    end
  end
end
