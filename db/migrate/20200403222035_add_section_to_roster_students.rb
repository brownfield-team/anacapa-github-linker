class AddSectionToRosterStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :roster_students, :section, :string
  end
end
