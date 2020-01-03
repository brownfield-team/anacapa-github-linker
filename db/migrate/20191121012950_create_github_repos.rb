class CreateGithubRepos < ActiveRecord::Migration[5.1]
  def change
    create_table :github_repos do |t|
      t.string :name
      t.string :url
      t.references :course, foreign_key: true
      t.datetime :last_updated_at

      t.timestamps
    end
  end
end
