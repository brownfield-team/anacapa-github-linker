class AddStartEndDateToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :start_date, :datetime, null:true
    add_column :courses, :end_date, :datetime, null:true
  end
end
