class AddRepoUrlToProjectTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :project_teams, :repo_url, :string
  end
end
