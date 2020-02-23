class CreateOrgTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :org_teams do |t|
      t.string :name
      t.string :url
      t.belongs_to :course

      t.timestamps
    end
  end
end
