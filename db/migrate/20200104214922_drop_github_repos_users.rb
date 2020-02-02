# The new join table is RepoContributor which includes extra columns, this table is now superfluous
class DropGithubReposUsers < ActiveRecord::Migration[5.1]
  def change
    drop_table :github_repos_users
  end
end
