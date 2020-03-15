class CreateTeamReposJob < CourseJob
  @job_name = "Create Team Repositories"
  @job_short_name = "create_team_repos"
  @job_description = "Creates a repository named with the provided name pattern for each team matching a specified team name pattern"

  def attempt_job(course_id, team_pattern, repo_pattern, permission_level)
    matching_teams = OrgTeam.where(course_id: params[:course_id]).where("name ~* ?", team_pattern)

    repo_creation_info = []
    matching_teams.each do |team|
      repo_name = repo_pattern.sub("{team}", team.slug)
      repo_creation_info << { :name => repo_name, :team_id => team.team_id, :permission => permission_level }


    end



    num_created = 0
    summary = "#{num_created} repositories created."
    UpdateGithubReposJob.perform_async(course_id)
    update_job_record_with_completion_summary(summary)
  end

  def perform(course_id, team_pattern, repo_pattern, permission_level)
    ActiveRecord::Base.connection_pool.with_connection do
      create_in_progress_job_record(course_id)
      begin
        attempt_job(course_id, team_pattern, repo_pattern, permission_level)
      rescue Exception => e
        rescue_job(e)
      end
    end
  end
end