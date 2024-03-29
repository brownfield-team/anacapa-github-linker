require 'json'
class RefreshProjectRepoCommitsJob < CourseJob
    @job_name = "Refresh Project Repo Commits"
    @job_short_name = "refresh_project_repo_commits"
    @job_description = "Runs the course_github_repo_get_commits_job for each repo that is designated as a project repo"
  
    def attempt_job(options)
      result_hash = iterate_over_project_repos
      "Done.  Results:<pre>#{JSON.pretty_generate(result_hash)}</pre>"
    end

    def iterate_over_project_repos
      result_hash = {
        project_repos: []
      }
      @course.project_repos.each do |repo|
        result_hash[:project_repos] << process_repo(repo)
      end

      return result_hash
    end

    def process_repo(repo)
      begin
        result = CourseGithubRepoGetCommits.new.perform(@course.id, repo.id)
        {
          name: repo.name,
          result: result
        }
      rescue Exception => e
        formatted_backtrace = JSON.pretty_generate(e.backtrace)
        exception_message = "An Exception Occurred: #{e.to_s} #{formatted_backtrace}"
        {
          name: repo.name,
          result: exception_message
        }
      end
    end
end