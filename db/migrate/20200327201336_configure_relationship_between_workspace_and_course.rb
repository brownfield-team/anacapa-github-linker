class ConfigureRelationshipBetweenWorkspaceAndCourse < ActiveRecord::Migration[5.1]
  def change
    remove_reference :courses, :slack_workspace
    add_reference :slack_workspaces, :course
  end
end
