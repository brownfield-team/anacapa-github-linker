class AddProjectToProjectTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :project_teams, :project, :string
  end
end
