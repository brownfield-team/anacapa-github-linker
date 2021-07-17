class CreateOrphanNames < ActiveRecord::Migration[5.2]
  def change
    create_table :orphan_names do |t|
      t.string :name
      t.belongs_to :course
      t.belongs_to :roster_student
    end
  end
end
