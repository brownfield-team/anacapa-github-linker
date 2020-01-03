class AddSummaryToCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :completed_jobs, :summary, :string
  end
end
