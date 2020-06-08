class RepoIssueEvent < ApplicationRecord
  belongs_to :roster_student
  belongs_to :github_repo, optional: true
end
