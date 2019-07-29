class AddHiddenToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :hidden, :boolean
  end
end
