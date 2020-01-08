class RefreshGithubReposJob < CourseJob

  @job_name = "Refresh Course GitHub Repository Records in DB"
  @job_short_name = "refresh_course_repos"

  def perform(course_id)
    ActiveRecord::Base.connection_pool.with_connection do
      super
      course = Course.find(course_id)
      org_repos = github_machine_user.organization_repositories(course.course_organization)
      students = course.roster_students
      summary = ""
      if org_repos.respond_to? :each
        summary = "Failed to fetch organization's repos. Either none exist or call to GitHub API failed."
      else
        num_created = 0
        org_repos.each do |github_repo|
          num_created += create_repo_record(github_repo, course, students)
        end
        summary = num_created.to_s + " repos created, " + (org_repos.size - num_created).to_s + " repos refreshed. "
        summary += find_repo_collaborators
      end
      update_job_record_with_completion_summary(summary)
    end
  end

  def create_repo_record(github_repo, course, students)
    num_created = 0
    repo_record = GithubRepo.new
    existing_record = GithubRepo.find_by_repo_id(github_repo.id)
    unless existing_record.nil?
      repo_record = existing_record
    else
      num_created += 1
      repo_record = GithubRepo.new
      repo_record.repo_id = github_repo.id
      repo_record.course = course
    end
    repo_record.name = github_repo.name
    repo_record.full_name = github_repo.full_name  # full_name includes organization name e.g. test-org/test-repo
    repo_record.url = github_repo.html_url
    repo_record.last_updated_at = github_repo.updated_at
    repo_record.save

    num_created
  end

  def find_repo_collaborators
    course = Course.find(course_id)
    course_repos = course.github_repos
    course_students = course.roster_students

    total_users_matched = 0; total_repos_matched = 0
    course_repos.each do |repo|
      users_matched = users_for_repo(repo, course_students)
      total_users_matched += users_matched
      total_repos_matched += users_matched >= 1 ? 1 : 0  # Repo is only counted in summary if it was matched to >= 1 user
    end
    "#{total_users_matched} collaborators found for #{total_repos_matched} repositories."
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
