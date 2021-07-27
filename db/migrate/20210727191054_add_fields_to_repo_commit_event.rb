class AddFieldsToRepoCommitEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :repo_commit_events, :package_lock_json_files_changed, :integer
    add_column :repo_commit_events, :package_lock_json_additions, :integer
    add_column :repo_commit_events, :package_lock_json_deletions, :integer
  end
end
