class AddVisibilityToGithubRepos < ActiveRecord::Migration[5.1]
  def change
    add_column :github_repos, :visibility, :string
  end
end
