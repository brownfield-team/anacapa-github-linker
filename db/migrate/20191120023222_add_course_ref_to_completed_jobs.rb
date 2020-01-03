class AddCourseRefToCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :completed_jobs, :course, foreign_key: true
  end
end
