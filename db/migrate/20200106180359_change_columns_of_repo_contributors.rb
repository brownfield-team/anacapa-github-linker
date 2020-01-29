class ChangeColumnsOfRepoContributors < ActiveRecord::Migration[5.1]
  def change
    remove_columns :repo_contributors, :substring_matched, :api_matched
    add_column :repo_contributors, :permission_level, :string
  end
end
