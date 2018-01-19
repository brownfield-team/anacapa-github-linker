class DropCoursesUsers < ActiveRecord::Migration[5.1]
  def change
    drop_table :courses_users
  end
end
