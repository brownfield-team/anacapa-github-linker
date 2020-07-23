class RepoIssueEvent < HookEventRecord
  belongs_to :roster_student
  def event_type
    'Issue'
  end
end
