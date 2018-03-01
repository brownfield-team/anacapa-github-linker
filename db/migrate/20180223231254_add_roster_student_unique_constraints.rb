class AddRosterStudentUniqueConstraints < ActiveRecord::Migration[5.1]
  def change
    add_index :roster_students, [:perm, :course_id], :unique => true
    add_index :roster_students, [:email, :course_id], :unique => true
  end
end
