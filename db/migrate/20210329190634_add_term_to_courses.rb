class AddTermToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :term, :string, null:true
  end
end
