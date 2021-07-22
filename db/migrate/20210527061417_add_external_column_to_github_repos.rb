class AddExternalColumnToGithubRepos < ActiveRecord::Migration[5.2]
  def change
    add_column :github_repos, :external, :boolean
  end
end
