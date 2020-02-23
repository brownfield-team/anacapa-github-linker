class CreateRepoTeamContributors < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_team_contributors do |t|
      t.belongs_to :org_team
      t.belongs_to :github_repo
      t.string :permission_level

      t.timestamps
    end
  end
end
