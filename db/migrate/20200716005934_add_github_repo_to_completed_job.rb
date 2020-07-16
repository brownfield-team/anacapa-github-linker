class AddGithubRepoToCompletedJob < ActiveRecord::Migration[5.1]
  def change
    add_reference :github_repos, :completed_jobs, index: true
  end
end
