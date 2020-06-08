class CreateRepoIssueEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_issue_events do |t|
      t.belongs_to :roster_student, foreign_key: true
      t.belongs_to :github_repo, foreign_key: true
      t.string :issue_id
      t.string :url
      t.string :action_type
      t.timestamps
    end
  end
end
