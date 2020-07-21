class AddCommitedViaWebToRepoCommitEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_commit_events, :committed_via_web, :boolean
  end
end
