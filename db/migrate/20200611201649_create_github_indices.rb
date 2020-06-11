class CreateGithubIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :org_teams, :team_id
    add_index :github_repos, :repo_id
    add_index :users, :uid
    add_index :repo_commit_events, :commit_hash
    add_index :repo_pull_request_events, :pr_id
    add_index :repo_issue_events, :issue_id
  end
end
