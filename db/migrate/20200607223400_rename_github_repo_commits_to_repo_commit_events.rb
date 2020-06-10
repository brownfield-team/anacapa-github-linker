class RenameGithubRepoCommitsToRepoCommitEvents < ActiveRecord::Migration[5.1]
  def change
    rename_table :github_repo_commits, :repo_commit_events
  end
end
