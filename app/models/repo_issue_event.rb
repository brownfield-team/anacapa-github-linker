class RepoIssueEvent < HookEventRecord
  def event_type
    'Issue'
  end
end
