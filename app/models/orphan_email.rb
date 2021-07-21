class OrphanEmail < ApplicationRecord
    belongs_to :course, optional: true
    belongs_to :roster_student, optional: true
      
    has_many :repo_commit_events, dependent: :destroy
    
    validates :email, presence: true, uniqueness: {scope: :course, message: "emails should be unique within a course"}
   
end
  