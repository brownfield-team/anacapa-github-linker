class AddSeveralFieldsToRepoIssueEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_issue_events, :title, :string
    add_column :repo_issue_events, :body, :string
    add_column :repo_issue_events, :state, :string
    add_column :repo_issue_events, :closed, :boolean
    add_column :repo_issue_events, :closed_at, :datetime
    add_column :repo_issue_events, :assignee_count, :integer
    add_column :repo_issue_events, :project_card_count, :integer
    add_column :repo_issue_events, :project_card_column_names, :string
    add_column :repo_issue_events, :project_card_column_project_names, :string
    add_column :repo_issue_events, :project_card_column_project_urls, :string
  end
end
