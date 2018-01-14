class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, :unique => true

      t.timestamps
    end
  end
end
