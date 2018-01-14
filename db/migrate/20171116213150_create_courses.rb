class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, :unique => true, null: false
      t.string :course_organization, null: false

      t.timestamps
    end
  end
end
