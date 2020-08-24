class RepoCommitEvent < HookEventRecord
  belongs_to :roster_student,  optional: true

  def event_type
    'Commit'
  end
end