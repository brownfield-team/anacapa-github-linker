module Api::Courses
    class RepoCommitEventsController < ApplicationController
        before_action :load_parent
        load_and_authorize_resource :github_repo, through: :course
        load_and_authorize_resource :repo_commit_event, through: :github_repo

        def index      
            @github_repo.repo_commit_events
        end
      
        def load_parent
            @github_repo = GithubRepo.find(params[:github_repo_id])
        end
    end
  end
