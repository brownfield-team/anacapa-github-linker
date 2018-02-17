class AddUserIdToRosterStudents < ActiveRecord::Migration[5.1]
  def change
    add_reference :roster_students, :user, foreign_key: true
  end
end
