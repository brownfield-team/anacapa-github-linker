class OrgTeam < ApplicationRecord
  belongs_to :course
  has_many :student_team_memberships, dependent: :destroy
  has_many :roster_students, through: :student_team_memberships
  has_many :repo_team_contributors
  has_many :github_repos, through: :repo_team_contributors
  has_one :project_team
end
