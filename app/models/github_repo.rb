class GithubRepo < ApplicationRecord
  belongs_to :course
  has_many :repo_contributors
  has_many :users, through: :repo_contributors
  has_many :repo_team_contributors
  has_many :org_teams, through: :repo_team_contributors, dependent: :destroy

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
end
