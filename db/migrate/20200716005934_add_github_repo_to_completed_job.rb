class AddGithubRepoToCompletedJob < ActiveRecord::Migration[5.1]
  def change
    add_reference :completed_jobs, :github_repos,  index: true
  end
end
