class AddRepoIdToOrgTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :org_teams, :project_repo_id, :string, :null => true
  end
end
