class OrphanName < ApplicationRecord
    belongs_to :course, optional: true
    belongs_to :roster_student, optional: true
      
    has_many :repo_commit_events, dependent: :destroy
    
    validates :name, presence: true, uniqueness: {scope: :course, message: "only unique names in a class"}
   
end
  