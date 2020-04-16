class AddGithubWebhooksEnabledToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :github_webhooks_enabled, :boolean
  end
end
