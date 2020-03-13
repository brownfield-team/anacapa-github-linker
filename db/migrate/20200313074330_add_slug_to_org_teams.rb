class AddSlugToOrgTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :org_teams, :slug, :string
  end
end
