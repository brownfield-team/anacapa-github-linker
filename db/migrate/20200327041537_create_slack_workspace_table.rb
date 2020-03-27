class CreateSlackWorkspaceTable < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_workspaces do |t|
      t.string :name
      t.string :access_token
      t.string :bot_access_token
    end

    add_reference :courses, :slack_workspace, foreign_key: true
  end
end
