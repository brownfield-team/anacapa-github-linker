class RepoCommitEvent < HookEventRecord
  def event_type
    'Commit'
  end
end