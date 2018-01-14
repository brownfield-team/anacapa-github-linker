class AddCourseToRosterStudent < ActiveRecord::Migration[5.1]
  def change
    add_reference :roster_students, :course, foreign_key: true
  end
end
