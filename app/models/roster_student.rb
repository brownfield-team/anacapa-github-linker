class RosterStudent < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :user, optional: true
  has_many :student_team_memberships, dependent: :destroy
  has_many :org_teams, through: :student_team_memberships
  has_one :slack_user, dependent: :destroy
  validates :perm, presence: true, uniqueness: {scope: :course, message: "only unique perms in a class"}
  validates :email, presence: true, uniqueness: {scope: :course, message: "only unique emails in a class", case_sensitive: false }
  def username
    # TODO: when linking roster_students to user accounts is implemented, this should return the name 
    # of this roster student's associated user
    return nil unless user
    user.username
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # Used when exporting CSV
  def teams_string
    team_str = ""
    user.org_teams.each do |team|
      team_str += "#{team.slug}/"
    end
    team_str.delete_suffix!("/") unless team_str.empty?
    team_str
  end
end
