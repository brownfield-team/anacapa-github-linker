class CreateRosterStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :roster_students do |t|
      t.string :perm,       null: false
      t.string :first_name, null: false
      t.string :last_name,  null: false
      t.string :email,      null:false

      t.timestamps
    end
  end
end
