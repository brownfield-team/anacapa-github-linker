class AddUrlTriggeredFromToCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :completed_jobs, :url_triggered_from, :string
  end
end
