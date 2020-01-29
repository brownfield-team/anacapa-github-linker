class RepoContributor < ApplicationRecord
  belongs_to :github_repo
  belongs_to :user
end