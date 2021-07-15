class AddColumnsToRepoPullRequestEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :repo_pull_request_events, :title, :string
    add_column :repo_pull_request_events, :body, :string
    add_column :repo_pull_request_events, :state, :string
    add_column :repo_pull_request_events, :reviewDecision, :string
    add_column :repo_pull_request_events, :changedFiles, :integer
    add_column :repo_pull_request_events, :closed, :boolean
    add_column :repo_pull_request_events, :closed_at, :datetime
    add_column :repo_pull_request_events, :merged, :boolean
    add_column :repo_pull_request_events, :merged_at, :datetime
    add_column :repo_pull_request_events, :assignee_count, :integer
    add_column :repo_pull_request_events, :assignee_logins, :string
    add_column :repo_pull_request_events, :assignee_names, :string
    add_column :repo_pull_request_events, :project_card_count, :integer
    add_column :repo_pull_request_events, :project_card_column_names, :string
    add_column :repo_pull_request_events, :project_card_column_project_names, :string
    add_column :repo_pull_request_events, :project_card_column_project_urls, :string
    add_column :repo_pull_request_events, :pull_request_created_at, :datetime
    add_column :repo_pull_request_events, :author_login, :string
  end
end
