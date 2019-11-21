class CreateJoinTableGithubReposUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :github_repos, :users do |t|
      # t.index [:github_repo_id, :user_id]
      # t.index [:user_id, :github_repo_id]
    end
  end
end
