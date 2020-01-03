class AddRepoIdToGithubRepos < ActiveRecord::Migration[5.1]
  def change
    add_column :github_repos, :repo_id, :integer
  end
end
