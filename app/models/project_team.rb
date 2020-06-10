class ProjectTeam < ApplicationRecord
  belongs_to :course
  belongs_to :org_team
  has_many :student_team_memberships, through: :org_team

  def as_json(options = {})
    super(options.merge(:include => {
        :student_team_memberships => {
            :include => {
                :roster_student => {
                    :methods => [:full_name, :username]
                }
            }
        },
        :org_team => {}
    }))
  end
end
