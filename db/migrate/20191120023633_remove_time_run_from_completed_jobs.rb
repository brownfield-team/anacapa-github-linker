class RemoveTimeRunFromCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :completed_jobs, :time_run, :datetime
  end
end
