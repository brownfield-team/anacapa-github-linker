class CourseGithubRepoGetCommits < CourseGithubRepoJob

    @job_name = "Get Commits for this Repo"
    @job_short_name = "course_github_repo_get_commits"
    @job_description = "Get commits for this repo"
    
    def attempt_job(options)
      "Job Complete; Getting commits not yet implemented."
    end
    
end
  