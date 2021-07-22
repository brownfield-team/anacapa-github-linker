class AddCreatedAtToRepoIssueEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_issue_events, :issue_created_at, :datetime
    add_column :repo_issue_events, :author_login, :string
  end
end
