class PurgeCourseReposJob < CourseJob

  @job_name = "Purge Course GitHub Records"
  @job_short_name = "purge_course_repos"
  @job_description = "Removes all cached records of this course organization's GitHub repos (not external repos) and teams from the database. Users will not be removed."

  def attempt_job(options)
    destroyed_repos = GithubRepo.where(:course_id => @course.id, :external => false).destroy_all
    destroyed_teams = OrgTeam.where(:course_id => @course.id).destroy_all
    "Purged #{pluralize destroyed_repos.size, "repo record"} and #{pluralize destroyed_teams.size, "team record"} from the database."
  end

  @confirmation_dialog = "Are you REALLY SURE you want to purge the course orgs GitHub repo data?"

  def self.confirmation_dialog
    @confirmation_dialog
  end
end
