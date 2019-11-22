class RefreshGithubReposJob < CourseJob

  @job_name = "Refresh Course GitHub Repositories"

  def perform(course_id)
    course = Course.find(course_id)
    org_repos = github_machine_user.organization_repositories(course.course_organization)
    students = course.roster_students
    if org_repos.size == 0
      summary = "Failed to fetch organization's repos. Either none exist or call to GitHub API failed."
      CompletedJob.create(job_name: RefreshGithubReposJob.job_name, course_id: course_id, summary: summary)
    end

    num_created = 0
    org_repos.each do |github_repo|
      num_created += create_repo_record(github_repo, course, students)
    end
    summary = num_created.to_s + " repos created, " + (org_repos.size - num_created).to_s + " repos refreshed."
    CompletedJob.create(job_name: RefreshGithubReposJob.job_name, course_id: course_id, summary: summary)
  end

  # Currently, this simply uses substring matching. In the future, it may actually request
  # a list of contributors from the GitHub API for the repository.
  def get_users_for_repo(github_repo, students)
    repo_name = github_repo.name.downcase
    students.select { |student| repo_name.include?(student.username.downcase) }
    students.map { |student| student.user }
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
    repo_record.url = github_repo.html_url
    repo_record.users << get_users_for_repo(github_repo, students)
    repo_record.last_updated_at = github_repo.updated_at

    repo_record.save

    num_created
  end
end
