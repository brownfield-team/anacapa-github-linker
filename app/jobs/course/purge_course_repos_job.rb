class PurgeCourseReposJob < CourseJob

  @job_name = "Purge Course GitHub Repo Records"
  @job_short_name = "purge_course_repos"
  @job_description = "Removes all cached records of this course organization's GitHub repos from the database."

  def attempt_job(options)
    destroyed_repos = GithubRepo.where(:course_id => @course.id).destroy_all
    "Purged #{pluralize destroyed_repos.size, "record"} from the database."
  end
end