class AddAdditionsAndDeletionsToRepoCommitEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_commit_events, :additions, :integer
    add_column :repo_commit_events, :deletions, :integer
  end
end
