class CreateOrgWebhookEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :org_webhook_events do |t|
      t.datetime :date_triggered
      t.string :event_type
      t.string :payload
      t.belongs_to :course, foreign_key: true
      t.belongs_to :roster_student, foreign_key: true
      t.belongs_to :github_repo, foreign_key: true
    end
  end
end
