class RepoTeamContributor < ApplicationRecord
  belongs_to :github_repo
  belongs_to :org_team
end
