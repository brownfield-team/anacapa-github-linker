class AddCourseToRepoCommitEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference :repo_commit_events, :course, foreign_key: true
  end
end
