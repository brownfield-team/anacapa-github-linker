class RosterStudent < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :user, optional: true 
  validates :perm, presence: true, uniqueness: {scope: :course, message: "only unique perms in a class"}
  validates :email, presence: true, uniqueness: {scope: :course, message: "only unique emails in a class", case_sensitive: false }
  def username 
    # TODO: when linking roster_students to user accounts is implemented, this should return the name 
    # of this roster student's associated user
    return nil unless user
    user.username
  end

end
