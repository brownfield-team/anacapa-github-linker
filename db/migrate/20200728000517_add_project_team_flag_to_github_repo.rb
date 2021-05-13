class AddProjectTeamFlagToGithubRepo < ActiveRecord::Migration[5.1]
  def change
    add_column :github_repos, :is_project_repo, :boolean
  end
end
