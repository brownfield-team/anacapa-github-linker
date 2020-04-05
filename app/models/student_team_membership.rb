class StudentTeamMembership < ApplicationRecord
  belongs_to :org_team
  belongs_to :roster_student
  validate :same_course?

  private
  def same_course?
    org_team.course_id == roster_student.course_id
  end
end