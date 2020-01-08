class RepoCollaboratorsJob < CourseJob

  @job_name = "Get All Repository Collaborators"
  @job_short_name = "get_repo_contributors"

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      super
      course = Course.find(course_id)
      course_repos = course.github_repos
      course_students = course.roster_students

      total_users_matched = 0; total_repos_matched = 0
      course_repos.each do |repo|
        users_matched = users_for_repo(repo, course_students)
        total_users_matched += users_matched
        total_repos_matched += users_matched >= 1 ? 1 : 0  # Repo is only counted in summary if it was matched to >= 1 user
      end
      summary = "#{total_users_matched} collaborators found for #{total_repos_matched} repositories."
      create_completed_job_record(summary, course_id) # TODO: Replace this when rebasing other PR changes
    end
  end

  # Substring matching and collaborator matching. Collaborator matching:
  # Matching by asking the GitHub API for all the direct collaborators on the repository
  # "direct" affiliation means that they actually contribute to the repo, not simply have permissions to it by default.
  def users_for_repo(repo_record, students)
    # Statistics gathering for job summary
    users_matched = 0

    repo_name = repo_record.name.downcase
    repo_collaborators_req = github_machine_user.collaborators(repo_record.full_name, affiliation: "direct")
    if repo_collaborators_req.respond_to? :each
      repo_collaborators = repo_collaborators_req.map { |collaborator| collaborator.login}
    else
      repo_collaborators = []
    end
    students.each do |student|
      unless student.user.nil? or student.user.username.nil?
        s_user = student.user
        is_substring_matched = repo_name.include?(s_user.username.downcase)
        is_api_matched = repo_collaborators.include?(s_user.username)

        if is_substring_matched || is_api_matched
          existing_record = RepoContributor.where(user: s_user, github_repo: repo_record).first
          unless existing_record.nil?
            existing_record.substring_matched = is_substring_matched
            existing_record.api_matched = is_api_matched
            existing_record.save
          else
            RepoContributor.new(user: s_user, github_repo: repo_record,
                                substring_matched: is_substring_matched, api_matched: is_api_matched)
          end
          users_matched += 1
        end
      end
    end
    users_matched
  end

end