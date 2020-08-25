class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.string :name
      t.bigint :course_id

      t.timestamps
    end
    add_foreign_key :assignments, :courses
  end
end
