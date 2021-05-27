json.extract! github_repo, :id, :name, :organization
json.path course_github_repo_path(github_repo.course, github_repo)
json.api_path api_course_github_repo_path(github_repo.course, github_repo)
