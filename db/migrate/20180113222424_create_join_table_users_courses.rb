class CreateJoinTableUsersCourses < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :courses do |t|
      t.index [:user_id, :course_id], :unique => true
      t.index [:course_id, :user_id], :unique => true
    end
  end
end
