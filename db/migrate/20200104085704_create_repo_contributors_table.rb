class CreateRepoContributorsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_contributors do |t|
      t.belongs_to :user
      t.belongs_to :github_repo
      t.boolean :substring_matched
      t.boolean :api_matched
    end
  end
end
