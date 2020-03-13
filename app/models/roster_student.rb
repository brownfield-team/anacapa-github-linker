class RosterStudent < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :user, optional: true 
  validates :perm, presence: true, uniqueness: {scope: :course, message: "Student IDs in a class must be unique."}
  validates :email, presence: true, uniqueness: {scope: :course, message: "Student emails in a class must be unique.", case_sensitive: false }
  def username 
    # TODO: when linking roster_students to user accounts is implemented, this should return the name 
    # of this roster student's associated user
    return nil unless user
    user.username
  end

end
