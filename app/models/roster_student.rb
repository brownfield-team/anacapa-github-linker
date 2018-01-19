class RosterStudent < ApplicationRecord
  belongs_to :courses, optional: true
  belongs_to :user, optional: true 

  def username 
    # TODO: when linking roster_students to user accounts is implemented, this should return the name 
    # of this roster student's associated user
    return nil unless user
    user.username
  end

  
end
