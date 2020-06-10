class CreateRepoPullRequestEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_pull_request_events do |t|
      t.belongs_to :github_repo, foreign_key: true
      t.belongs_to :roster_student, foreign_key: true
      t.string :url
      t.string :pr_id
      t.string :action_type

      t.timestamps
    end
  end
end
