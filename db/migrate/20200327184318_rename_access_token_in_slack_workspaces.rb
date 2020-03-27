class RenameAccessTokenInSlackWorkspaces < ActiveRecord::Migration[5.1]
  def change
    rename_column(:slack_workspaces, :access_token, :user_access_token)
    add_column(:slack_workspaces, :team_id, :string)
    add_column(:slack_workspaces, :app_id, :string)
  end
end
