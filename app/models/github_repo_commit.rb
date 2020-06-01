class GithubRepoCommit < ApplicationRecord
  belongs_to :github_repo
  belongs_to :roster_student
end