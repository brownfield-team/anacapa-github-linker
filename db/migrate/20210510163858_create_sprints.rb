class CreateSprints < ActiveRecord::Migration[5.2]
  def change
    create_table :sprints do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
