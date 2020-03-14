class CreateTeamReposJob < CourseJob
  @job_name = "Create Team Repositories"
  @job_short_name = "create_team_repos"
  @job_description = "Creates a repository named with the provided name pattern for each team matching a specified team name pattern"

  def attempt_job(course_id, args)
    
  end

  def perform(course_id, args)
    ActiveRecord::Base.connection_pool.with_connection do
      create_in_progress_job_record(course_id)
      begin
        attempt_job(course_id, args)
      rescue Exception => e
        rescue_job(e)
      end
    end
  end
end