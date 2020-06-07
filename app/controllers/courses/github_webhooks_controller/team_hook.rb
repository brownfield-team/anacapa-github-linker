class Courses::GithubWebhooksController
  class TeamHook
    def self.process_hook(course, payload)
      team_info = payload[:team]
      existing_team_record = OrgTeam.find_by_team_id(team_info[:node_id])
      case payload[:action]
      when "created"
        existing_team_record.try(:destroy)
        OrgTeam.create(name: team_info[:name], slug: team_info[:slug], url: team_info[:html_url], team_id: team_info[:node_id], course: course)
      when "deleted"
        existing_team_record.try(:destroy)
      when "edited"
        return if existing_team_record.nil?
        existing_team_record.update(name: team_info[:name], slug: team_info[:slug], url: team_info[:html_url])
        upsert_team_repo_permissions(existing_team_record, payload) if payload[:changes].key? :repository
      when "added_to_repository"
        return if existing_team_record.nil?
        upsert_team_repo_permissions(existing_team_record, payload)
      when "removed_from_repository"
        return if existing_team_record.nil?
        contributor_record = RepoTeamContributor.where(org_team: existing_team_record)
                                 .includes(:github_repo).references(:github_repo).merge(GithubRepo.where(repo_id: payload[:repository][:id])).first
        contributor_record.try(:destroy)
      else
        return
      end
    end

    def self.upsert_team_repo_permissions(team, payload)
      repo_record = GithubRepo.where(repo_id: payload[:repository][:id]).first
      return if repo_record.nil?
      contributor_record = RepoTeamContributor.where(org_team: team, github_repo: repo_record).first_or_initialize
      repo_permissions = payload[:repository][:permissions]
      if repo_permissions[:admin]
        contributor_record.permission_level = "admin"
      elsif repo_permissions[:maintain]
        contributor_record.permission_level = "maintain"
      elsif repo_permissions[:push]
        contributor_record.permission_level = "push"
      elsif repo_permissions[:pull]
        contributor_record.permission_level = "pull"
      end
      contributor_record.save
    end
  end
end