class AddFullNameToGithubRepos < ActiveRecord::Migration[5.1]
  def change
    add_column :github_repos, :full_name, :string
  end
end
