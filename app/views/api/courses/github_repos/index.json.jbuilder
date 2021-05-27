json.array! @github_repos do |github_repo|
  json.partial! "api/courses/github_repos/github_repo", github_repo: github_repo, include_course: false
end
