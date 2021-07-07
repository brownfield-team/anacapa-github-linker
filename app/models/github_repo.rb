require 'zlib'

class GithubRepo < ApplicationRecord
  belongs_to :course
  has_many :repo_contributors
  has_many :users, through: :repo_contributors
  has_many :repo_team_contributors, dependent: :destroy
  has_many :org_teams, through: :repo_team_contributors
  has_many :org_webhook_events, dependent: :destroy
  has_many :repo_commit_events, dependent: :destroy
  has_many :repo_issue_events, dependent: :destroy
  has_many :repo_pull_request_events, dependent: :destroy

  # Note: most (if not all) of the GitHub-related objects store a unique identifier for that object assigned by GitHub.
  # These are, by our convention, something like #repo_id, #hook_id, #team_id, etc.
  # For all but repositories and users (uid), we use the "node_id" string provided by GitHub to fill this field. HOWEVER, for repositories (repo_id),
  # because GitHub sometimes omits the node_id for repos, we use the GitHub "id" integer (in GraphQL responses, this is called the "databaseId").

  def organization
    full_name.split("/")[0]
  end

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

  def self.create_repo_from_name(organization, name, course)
    repo_info = GithubRepo.fetch_repo_info(organization, name)
    return nil if repo_info.nil?
    GithubRepo.create(
      course: course,
      name: repo_info[:name],
      repo_id: repo_info[:databaseId],
      url: repo_info[:url],
      full_name: repo_info[:nameWithOwner],
      visibility: repo_info[:isPrivate] ? "private" : "public",
      last_updated_at: repo_info[:updatedAt],
      external: course.course_organization != organization,
    )
  end

  def self.fetch_repo_info(organization, name)
    query_variables = { organization: organization, name: name }
    repo_query = <<-GRAPHQL
    query($organization: String!, $name: String!) { 
      repository(owner: $organization, name: $name) {
        databaseId
        name
        url
        updatedAt
        isPrivate
        nameWithOwner
        owner {
          login
        }
      }
    }
    GRAPHQL
    fetched_repo = github_machine_user.post '/graphql', { query: repo_query, variables: query_variables }.to_json
    fetched_repo.to_h.dig(:data, :repository)
  end

  def self.commit_csv_export_headers
    %w[
      include
      commit_hash
      teams
      doc_only
      author_consents
      url
      message
      github_repo_name
      github_repo_url
      github_repo_type
      roster_student_id
      roster_student_name
      roster_student_github_id
      branch
      files_changed
      additions
      deletions
      commit_timestamp
      filenames_changed
      committed_via_web
      author_login
      author_name
      author_email
      merge_commit_a
      merge_commit_b
    ]
  end

  def self.doc_only_commit?(c)
    begin
      filenames = c.filenames_changed[1..-2].gsub("\"", "").split(",")
      filenames.map { |filename|
        filename.end_with?(".md")
      }.reduce(:|)
    rescue
      return false
    end
  end

  def self.merge_commit?(c)
    [
      "Merge branch",
      "Merge pull request",
      "Merged remote-tracking branch"
    ].map { |p|
      c&.message&.start_with?(p)
    }.reduce(:|)
  end

  def self.alt_merge_commit?(c)
    [
      "merge ",
      "merged ",
      "merging "
    ].map { |p|
      c&.message&.downcase&.start_with?(p)
    }.reduce(:|)
  end

  def self.commit_meets_inclusion_criteria?(repo, c)
    return false if doc_only_commit?(c)
    return false if c.roster_student.nil?
    return false if repo.visibility == "private" && !c.roster_student.consents
    return false if alt_merge_commit?(c)
    true
  end

  def self.team_names(c)
    "TBD"
  end

  # self.method so it can be reused in course.rb
  def self.commit_csv_export_fields(repo, c)

    author_teams_array = c.roster_student&.org_teams&.map { |team| team.name }
    author_teams = self.array_or_singleton_to_s(author_teams_array)

    [
      commit_meets_inclusion_criteria?(repo, c),
      c.commit_hash,
      author_teams,
      doc_only_commit?(c),
      c.roster_student&.consents,
      c.url,
      c.message,
      repo.name,
      repo.url,
      repo.visibility,
      c.roster_student_id,
      c.roster_student&.full_name,
      c.roster_student&.user&.username,
      c.branch,
      c.files_changed,
      c.additions,
      c.deletions,
      c.commit_timestamp,
      c.filenames_changed,
      c.committed_via_web,
      c.author_login,
      c.author_name,
      c.author_email,
      merge_commit?(c),
      alt_merge_commit?(c)
    ]
  end

  # self.method so it can be reused in course.rb
  def self.issue_csv_export_headers
    %w[
      include
      random
      teams
      author_consents
      state
      done
      url
      github_repo_name
      github_repo_url
      github_repo_visibility
      title
      created_at
      closed
      closed_at
      author_login
      author_name
      author_teams
      assignee_count
      assignee_logins
      assignee_names
      assignee_teams
      project_card_count
      project_column_names
      project_names
      project_urls
      checklist_items
      checked
      unchecked
    ]
  end

  def self.in_done_column(i)
    i.project_card_column_names&.upcase&.include?("DONE")
  end

  def self.issue_meets_inclusion_criteria?(repo, i)
    return false if !i.closed and not in_done_column(i)
    return false if i.roster_student.nil?
    return false if repo.visibility == "private" && !i.roster_student.consents
    true
  end

  def self.assignee_list_to_array(assignees)
    begin
      return [] if assignees.nil? or assignees == "[]" or assignees == ""
      cleaned = assignees.gsub("\"", "").gsub("[", "").gsub("]", "").gsub(" ", "")
      puts("\n##### cleaned: #{cleaned} \n")
      cleaned.split(",")
    end
  end

  def self.issue_csv_export_fields(repo, i)
    author_teams_array = i.roster_student&.org_teams&.map { |team| team.name }
    author_teams = self.array_or_singleton_to_s(author_teams_array)

    assignee_teams_array = []
    puts("\n##### i.assignee_logins: #{i.assignee_logins} \n")

    assignees = assignee_list_to_array(i.assignee_logins)
    puts("\n##### assignees: #{assignees} \n")
    assignees.map { |login|
      student = repo.course.student_for_github_username(login)
      student_teams_array = student&.org_teams&.map { |team| team.name }
      assignee_teams_array |= student_teams_array unless student_teams_array.nil?
    }
    assignee_teams = self.array_or_singleton_to_s(assignee_teams_array)
    puts("\n\n##### assignee_teams: #{assignee_teams} \n\n")

    [
      issue_meets_inclusion_criteria?(repo, i),
      issue_hash(i),
      author_teams || assignee_teams,
      i.roster_student&.consents,
      i.state,
      self.in_done_column(i),
      i.url,
      repo.name,
      repo.url,
      repo.visibility,
      i.title,
      i.issue_created_at,
      i.closed,
      i.closed_at,
      i.author_login,
      i.roster_student&.full_name,
      author_teams,
      i.assignee_count,
      i.assignee_logins,
      i.assignee_names,
      assignee_teams,
      i.project_card_count,
      i.project_card_column_names,
      i.project_card_column_project_names,
      i.project_card_column_project_urls,
      self.checklist_item_count(i.body),
      self.checklist_item_checked_count(i.body),
      self.checklist_item_unchecked_count(i.body),
    ]
  end

  def export_commits_to_csv
    CSV.generate(headers: true) do |csv|
      csv << GithubRepo.commit_csv_export_headers
      repo_commit_events.each do |c|
        csv << GithubRepo.commit_csv_export_fields(self, c)
      end
    end
  end

  def export_issues_to_csv
    CSV.generate(headers: true) do |csv|
      csv << GithubRepo.issue_csv_export_headers
      repo_issue_events.each do |c|
        csv << GithubRepo.issue_csv_export_fields(self, c)
      end
    end
  end

  def self.checklist_item_count(body)
    # both checked and unchecked
    return 0 if body.nil?
    body.scan(/\r\n[ ]*- \[[ x]\]/).count
  end

  def self.checklist_item_checked_count(body)
    return 0 if body.nil?
    # both checked and unchecked
    body.scan(/\r\n[ ]*- \[x\]/).count
  end

  def self.checklist_item_unchecked_count(body)
    return 0 if body.nil?
    # both checked and unchecked
    body.scan(/\r\n[ ]*- \[ \]/).count
  end

  def self.array_or_singleton_to_s(a)
    return nil if a.nil? or a.length == 0
    return a.first.to_s if a.length == 1
    a.sort.to_s
  end

  def self.issue_hash(i)
    basis = "#{i.url} #{i.issue_created_at} #{i.title} #{i.body}"
    Zlib.crc32 basis
  end
end
