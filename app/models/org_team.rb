class OrgTeam < ApplicationRecord
  belongs_to :course
  has_many :student_team_memberships
  has_many :roster_students, through: :student_team_memberships
end
