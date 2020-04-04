class AddTeamIdToOrgTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :org_teams, :team_id, :string
  end
end
