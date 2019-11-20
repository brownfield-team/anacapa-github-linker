class CreateCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :completed_jobs do |t|
      t.string :job_name
      t.datetime :time_run

      t.timestamps
    end
  end
end
