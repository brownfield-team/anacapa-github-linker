json.extract! github_repo, :id, :name, :organization, :is_project_repo, :course_id
if include_course.present?
  json.extract! github_repo, :course
end
json.commit_count github_repo.repo_commit_events.count
json.issue_count github_repo.repo_issue_events.count
json.pr_count github_repo.repo_pull_request_events.count
json.path course_github_repo_path(github_repo.course, github_repo)
json.api_path api_course_github_repo_path(github_repo.course, github_repo)
