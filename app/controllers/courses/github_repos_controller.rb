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
      @course = Course.find(params[:course_id])
      @github_repo = GithubRepo.find(params[:id])
    end

    def run_job
      job_name = params[:job_name]
      job = course_github_repo_job_list.find { |job| job.job_short_name == job_name }
      # This is a hack. It should be replaced as soon as possible, hopefully after authorization in the app is redone.
      if job.permission_level == "admin" && !user.has_role?("admin")
        redirect_to course_jobs_path, alert: "You do not have permission to run this job. Ask an admin to run it for you."
      end
      job.perform_async(params[:course_id].to_i, params[:github_repo_id].to_i)
      redirect_to course_github_repo_path(params[:course_id],params[:github_repo_id]), notice: "Job successfully queued."
    end

    # List of course jobs to make available to run
    def course_github_repo_job_list
      # @course = Course.find(params[:course_id])
      # @github_repo = GithubRepo.find(params[:id])
      jobs = [CourseGithubRepoTestJob, CourseGithubRepoGetCommits]
      jobs
    end
    helper_method :course_github_repo_job_list

    # List of course jobs to make available to run
    def course_github_repo_job_info_list
      jobs = course_github_repo_job_list
      jobs_info = jobs.map{ |j| 
        j.instance_values.merge({ 
          "last_run" => j.itself.last_run,
          "job_description" => j.itself.job_description
          }
        )  
      }
      jobs_info
    end
    helper_method :course_github_repo_job_info_list

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_github_repo
        @github_repo = GithubRepo.find(params[:id])
      end

      def machine_user
        client = Octokit_Wrapper::Octokit_Wrapper.machine_user
      end

      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end

end
