class AddIsOrgMemberToRosterStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :roster_students, :is_org_member, :boolean
  end
end
