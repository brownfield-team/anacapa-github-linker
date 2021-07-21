class CreateOrphanEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :orphan_emails do |t|
      t.string :email
      t.belongs_to :course
      t.belongs_to :roster_student
    end
  end
end
