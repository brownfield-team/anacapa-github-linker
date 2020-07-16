class GithubRepoTestJob < GithubRepoJob

    @job_name = "Github Repo Test Job"
    @job_short_name = "github_repo_test_job"
    @job_description = "Adds a completed job record for this course/github_repo for testing purposes."
  
    def attempt_job(options)
      "Test completed."
    end
  end
  