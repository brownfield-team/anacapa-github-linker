class AddNodeIdToGithubRepos < ActiveRecord::Migration[5.1]
  def change
    add_column :github_repos, :node_id, :string
  end
end
