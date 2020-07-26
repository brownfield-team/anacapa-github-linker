class CreateInformedConsents < ActiveRecord::Migration[5.1]
  def change
    create_table :informed_consents do |t|
      t.string :perm
      t.string :name
      t.string :email
      t.bigint :course_id
      t.bigint :roster_student_id
      t.boolean :student_consents

      t.index ["course_id"], name: "index_informed_consents_on_course_id"
      t.index ["email", "course_id"], name: "index_informed_consents_on_email_and_course_id", unique: true
      t.index ["perm", "course_id"], name: "index_informed_consents_on_perm_and_course_id", unique: true
      t.index ["roster_student_id", "course_id"], name: "index_informed_consents_on_roster_student_id_and_course_id", unique: true

      t.timestamps
    end
  end
end
