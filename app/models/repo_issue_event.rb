class RepoIssueEvent < HookEventRecord
  belongs_to :roster_student, optional: true

  def event_type
    'Issue'
  end
end
