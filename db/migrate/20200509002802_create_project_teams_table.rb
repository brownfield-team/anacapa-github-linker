class CreateProjectTeamsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :project_teams do |t|
      t.string :name
      t.string :qa_url
      t.string :production_url
      t.string :team_chat_url
      t.string :meeting_time
      t.belongs_to :course
      t.references :github_repo, foreign_key: true
      t.references :org_team, foreign_key: true
    end
    create_table :project_roles do |t|
      t.string :name
      t.string :color
    end
    add_reference :student_team_memberships, :project_role, foreign_key: true
  end
end
