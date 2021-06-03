class AddGithubIdToRepoCommitEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_commit_events, :author_login, :string
    add_column :repo_commit_events, :author_name, :string
    add_column :repo_commit_events, :author_email, :string
  end
end
