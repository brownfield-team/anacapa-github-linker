class CreateGithubTeamsJob < CourseJob
  def attempt_job(options)
    teams_to_create = options[:teams]
    current_user = github_machine_user.user.login
    # There is a way to create teams with a list of maintainers, but if there is a problem with any one of those maintainers,
    # it blows up the whole operation. So, we just do everything one by one for safety.
    # These operations with unverified data are very exception prone, and we don't want one already-existing team or
    # failed user add to crash the whole thing, so all the requests are wrapped in exception handling blocks.
    teams_created = 0; users_added = 0; teams_not_created = 0; users_not_added = 0
    teams_to_create.each do |team_name, members|
      begin
        response = github_machine_user.create_team(@course.course_organization, { :name => team_name, :privacy => "closed" })
        teams_created += 1
        members.each do |user|
          begin
            github_machine_user.add_team_member(response.id, user)
          rescue Octokit::Error => e
            users_not_added += 1
            puts e
          end
        end
        unless members.include? current_user
          begin
            github_machine_user.remove_team_member(response.id, current_user)
            users_added += 1
          rescue Octokit::Error => e
            puts e
          end
        end
      rescue Octokit::Error => e
        teams_not_created += 1
        puts e
      end
    end
    "#{pluralize teams_created, "team"} created and #{pluralize users_added, "user"} to teams. Failed to create #{pluralize teams_not_created, "team"} and
failed to add #{pluralize users_not_added, "user"}"
  end
end