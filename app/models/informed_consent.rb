class InformedConsent < ApplicationRecord
    belongs_to :course, optional: true
    belongs_to :roster_student, optional: true
end
