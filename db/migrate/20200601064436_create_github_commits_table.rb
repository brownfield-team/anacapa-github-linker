class CreateGithubCommitsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :github_repo_commits do |t|
      t.belongs_to :github_repo, foreign_key: true
      t.belongs_to :roster_student, foreign_key: true
      t.string :message
      t.string :hash
      t.string :url
      t.integer :files_changed
      t.datetime :commit_timestamp
      t.timestamps
    end
  end
end
