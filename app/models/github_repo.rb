class GithubRepo < ApplicationRecord
  belongs_to :course, optional: true
  has_many :repo_contributors
  has_many :users, through: :repo_contributors
  has_many :repo_team_contributors, dependent: :destroy
  has_many :org_teams, through: :repo_team_contributors
  has_many :org_webhook_events

  # Note: most (if not all) of the GitHub-related objects store a unique identifier for that object assigned by GitHub.
  # These are, by our convention, something like #repo_id, #hook_id, #team_id, etc.
  # For all but repositories and users (uid), we use the "node_id" string provided by GitHub to fill this field. HOWEVER, for repositories (repo_id),
  # because GitHub sometimes omits the node_id for repos, we use the GitHub "id" integer (in GraphQL responses, this is called the "databaseId").

  def find_contributors
    # This query gets certain information about a student, their user, and relationship to the repository in question.
    # It is written in raw SQL because it would take several queries using Rails syntax.
    query = <<-SQL
        SELECT rs.first_name, rs.last_name, rs.id, u.username, rc.permission_level
        FROM users u
          JOIN roster_students rs ON (u.id = rs.user_id and #{self.course_id} = rs.course_id)
          JOIN repo_contributors rc ON u.id = rc.user_id
        WHERE #{self.id} = rc.github_repo_id
    SQL
    ActiveRecord::Base.connection.exec_query(query)
  end

  def find_team_contributors
    query = <<-SQL
      SELECT t.name, t.id, t.url, t.slug, rtc.permission_level
      FROM org_teams t
        JOIN repo_team_contributors rtc ON t.id = rtc.org_team_id
      WHERE #{self.id} = rtc.github_repo_id
    SQL
    ActiveRecord::Base.connection.exec_query(query)
  end
end
