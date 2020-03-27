class CreateSlackWorkspaceTable < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_workspaces do |t|
      t.string :name
      t.string :access_token
      t.belongs_to :course
    end

    add_reference :courses, :slack_workspace, foreign_key: true
  end
end
