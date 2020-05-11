class ProjectTeam < ApplicationRecord
  belongs_to :course
  has_one :org_team
end
