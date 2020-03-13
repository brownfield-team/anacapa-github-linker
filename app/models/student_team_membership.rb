class StudentTeamMembership < ApplicationRecord
  belongs_to :org_team
  belongs_to :roster_student
end