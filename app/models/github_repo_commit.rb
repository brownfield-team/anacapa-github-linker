class GithubRepoCommit < ApplicationRecord
  belongs_to :github_repo, optional: true
  belongs_to :roster_student
end