class RemoveUrlTriggeredFromFromCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :completed_jobs, :url_triggered_from, :string
  end
end
