# This controller is nested in the routing hierarchy as a child controller of 
# courses_controller
# see this tutorial for details on how we do this https://gist.github.com/jhjguxin/3074080
require 'Octokit_Wrapper'

module Courses
  class GithubReposController < ApplicationController
    layout 'courses'
    before_action :load_parent
    before_action :set_github_repo, only: [:show]

    load_and_authorize_resource :course
    load_and_authorize_resource :github_repo, through: :course

    def index
      @github_repos = @parent.github_repos.all
    end

    def show
      # @github_repo = @parent.github_repos.find(params[:id])
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_github_repo
        # @github_repo = GithubRepos.find(params[:id])
      end

      def machine_user
        client = Octokit_Wrapper::Octokit_Wrapper.machine_user
      end

      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end

end
