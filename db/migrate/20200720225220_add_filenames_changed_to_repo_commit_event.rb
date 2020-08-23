class AddFilenamesChangedToRepoCommitEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :repo_commit_events, :filenames_changed, :string
  end
end
