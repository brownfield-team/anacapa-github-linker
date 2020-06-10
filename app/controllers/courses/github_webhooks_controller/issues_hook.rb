class Courses::GithubWebhooksController
  class IssuesHook
    def self.process_hook(course, payload)
      event_record = RepoIssueEvent.new
      issue = payload[:issue]
      event_record.url = issue[:html_url]
      event_record.issue_id = issue[:node_id]
      action = payload[:action]
      case payload[:action]
      when "opened"
        return
      when "deleted"
      when "closed"
      when "assigned"
      when "unassigned"
      when "milestoned"
      when "demilestoned"
      else
        return
      end
    end
  end
end
