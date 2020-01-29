class RefreshGithubReposJob < CourseJob

  @job_name = "Refresh Course GitHub Repository Records"
  @job_short_name = "refresh_course_repos"
  @job_description = "Fetches all of the course org's repositories from GitHub and refreshes the cached records."

  def attempt_job(course_id)
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
      summary = num_created.to_s + " repos created, " + (org_repos.size - num_created).to_s + " repos refreshed."
      # RepoCollaboratorsJob.perform_async(course_id)
    end
    update_job_record_with_completion_summary(summary)
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
    repo_record.name = github_repo.full_name  # full_name includes organization name e.g. test-org/test-repo
    repo_record.url = github_repo.html_url
    repo_record.users << get_users_for_repo(repo_record, students)
    repo_record.last_updated_at = github_repo.updated_at
    repo_record.save

    num_created
  end

  # Currently, this simply uses substring matching. In the future, it may actually request
  # a list of contributors from the GitHub API for the repository.
  def get_users_for_repo(repo_record, students)
    repo_name = repo_record.name.downcase
    filtered_students = students.select do |student|
      unless student.username.nil?
        next(repo_name.include?(student.username.downcase) && !repo_record.users.include?(student.user))
      end
    end
    filtered_students.map { |student| student.user }
  end
end
