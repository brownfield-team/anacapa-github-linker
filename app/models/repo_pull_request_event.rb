class RepoPullRequestEvent < HookEventRecord
  def event_type
    'Pull Request'
  end
end
