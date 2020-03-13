class CreateStudentsTeamsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :student_team_memberships do |t|
      t.belongs_to :roster_student
      t.belongs_to :org_team
      t.string :role

      t.timestamps
    end
  end
end
