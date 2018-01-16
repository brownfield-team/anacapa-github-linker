class RosterStudent < ApplicationRecord
  belongs_to :courses, optional: true

  def username 
    # TODO: when linking roster_students to user accounts is implemented, this should return the name 
    # of this roster student's associated user
    return nil
  end
  
end
