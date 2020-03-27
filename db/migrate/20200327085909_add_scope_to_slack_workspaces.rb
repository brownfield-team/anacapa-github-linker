class AddScopeToSlackWorkspaces < ActiveRecord::Migration[5.1]
  def change
    add_column :slack_workspaces, :scope, :string
  end
end
