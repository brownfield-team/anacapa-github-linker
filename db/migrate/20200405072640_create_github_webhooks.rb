class CreateGithubWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :github_webhooks do |t|
      t.integer :hook_id
      t.belongs_to :course, foreign_key: true
      t.string :hook_url
    end
  end
end
