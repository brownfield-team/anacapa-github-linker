class AddGithubRepoToCompletedJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :completed_jobs, :github_repo, foreign_key: true
  end
end
