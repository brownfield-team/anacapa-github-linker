class AddEnrolledToRosterStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :roster_students, :enrolled, :boolean, default: true
  end
end
