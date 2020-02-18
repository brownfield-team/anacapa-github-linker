class AddOrgMembershipTypeToRosterStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :roster_students, :org_membership_type, :string
  end
end
