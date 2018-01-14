class RosterStudent < ApplicationRecord
  belongs_to :courses, optional: true
end
