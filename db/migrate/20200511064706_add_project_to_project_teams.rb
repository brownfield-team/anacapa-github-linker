class AddProjectToProjectTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :project_teams, :project, :string
    add_column :project_teams, :milestones_url, :string
    add_column :project_teams, :project_board_url, :string
  end
end
