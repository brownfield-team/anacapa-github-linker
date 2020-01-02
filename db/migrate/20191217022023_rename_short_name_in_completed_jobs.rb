class RenameShortNameInCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    rename_column :completed_jobs, :short_name, :job_short_name
  end
end
