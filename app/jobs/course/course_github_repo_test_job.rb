class CourseGithubRepoTestJob < CourseGithubRepoJob

    @job_name = "Course Github Repo Test Job"
    @job_short_name = "course_github_repo_test_job"
    @job_description = "Adds a completed job record for this course and github repo for testing purposes."
    
  
    def attempt_job(options)
      "Test completed."
    end
  
    @confirmation_dialog = "Are you sure you want to run this course/github_repo test job?"
  
    def self.confirmation_dialog
      @confirmation_dialog
    end
  
end
  