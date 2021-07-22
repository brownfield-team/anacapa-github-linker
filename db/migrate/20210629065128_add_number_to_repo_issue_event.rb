class AddNumberToRepoIssueEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :repo_issue_events, :number, :integer
  end
end
