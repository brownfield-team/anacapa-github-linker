class AddSlackWorkspaceIdToSlackUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :slack_users, :slack_workspace, foreign_key: true
  end
end
