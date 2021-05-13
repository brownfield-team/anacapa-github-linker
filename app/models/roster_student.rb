class RosterStudent < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :user, optional: true
  has_many :student_team_memberships, dependent: :destroy
  has_many :org_teams, through: :student_team_memberships
  has_many :org_webhook_events
  has_one :slack_user, dependent: :destroy

  has_many :repo_commit_events, dependent: :destroy
  has_many :repo_issue_events, dependent: :destroy
  has_many :repo_pull_request_events, dependent: :destroy

  validates :perm, presence: true, uniqueness: {scope: :course, message: "only unique perms in a class"}
  validates :email, presence: true, uniqueness: {scope: :course, message: "only unique emails in a class", case_sensitive: false }
  def username
    return nil unless user
    user.username
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # Used when exporting CSV
  def teams_string
    team_str = ""
    org_teams.each do |team|
      team_str += "#{team.slug}/"
    end
    return nil if team_str.empty?
    team_str.delete_suffix("/")
  end

  def is_ta?
    !user.nil? && user.has_role?(:ta, course)
  end

  def consents
    informed_consent = course.informed_consents.where(roster_student_id: id).first
    return nil if informed_consent.nil?
    informed_consent.student_consents
  end

  def consents_as_Y_or_N
    student_consents = consents
    return nil if student_consents.nil?
    student_consents ? "Y" : "N"
  end
end
