class RepoCommitEvent < HookEventRecord
  belongs_to :roster_student
  
  def event_type
    'Commit'
  end
end