module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :record_webhook_event, only: :create

    def record_webhook_event
      event_record = @course.org_webhook_events.new
      event_record.event_type = request.headers['X-GitHub-Event']
      event_record.payload = json_body.to_json
      event_record.roster_student = @course.student_for_uid(json_body[:sender][:id])
      if json_body[:repository].present?
        event_record.github_repo = GithubRepo.find_by_repo_id(json_body[:repository][:id])
      end
      event_record.save
    end

    def github_organization(payload)
      case payload[:action]
      when "member_invited"
        student = @course.student_for_uid(payload[:invitation][:id])
        return if student.nil?
        student.org_membership_type = "Invited"
        student.save
      when "member_added"
        student = @course.student_for_uid(payload[:membership][:user][:id])
        return if student.nil?
        student.is_org_member = true
        student.org_membership_type = payload[:membership][:role].capitalize
        student.save
      when "member_removed"
        student = @course.student_for_uid(payload[:membership][:user][:id])
        return if student.nil?
        student.is_org_member = false
        student.org_membership_type = nil
        student.save
      when "renamed"
        @course.course_organization = payload[:organization][:login]
        @course.save
      else
        return
      end
    end

    def github_repository(payload)
      repo_info = payload[:repository]
      existing_repo = GithubRepo.where(course: @course, repo_id: repo_info[:id]).first
      case payload[:action]
      when "created"
        existing_repo.try(:destroy)
        repo_visibility = repo_info[:private] ? "private" : "public"
        GithubRepo.create(course: @course, name: repo_info[:name], full_name: repo_info[:full_name], url: repo_info[:html_url], repo_id: repo_info[:id], visibility: repo_visibility)
      when "deleted"
        existing_repo.try(:destroy)
      when "edited"
        # Nothing to do here for now
      when "renamed"
        return if existing_repo.nil?
        existing_repo.name = payload[:repository][:name]
        existing_repo.full_name = payload[:repository][:full_name]
        existing_repo.save
      when "publicized"
        return if existing_repo.nil?
        existing_repo.visibility = "public"
        existing_repo.save
      when "privatized"
        return if existing_repo.nil?
        existing_repo.visibility = "private"
        existing_repo.save
      else
        return
      end
    end

    def github_member(payload)
      user = User.where(uid: payload[:member][:id]).first
      repository = GithubRepo.where(repo_id: payload[:repository][:id]).first
      return if user.nil? || repository.nil?
      existing_contributor_record = RepoContributor.where(github_repo: repository, user: user).first
      case payload[:action]
        # GitHub's API has some kind of hilarious prank where this webhook won't give you the user's permission on the repository.
        # The kicker? When you change a user's repo permission it sends a webhook. But that webhook only contains
        # the OLD permission. Meaning: if you change a user's permission from read to write, it'll send you a webhook that basically says
        # "that user used to have read permission". I think there's a quantum superposition joke in here, but I'll have to workshop that some more.
        # Anyway, I filed a bug report but in the meantime I'm just having this webhook make an API request to get the permission level.
      when "added"
        existing_contributor_record.try(:destroy)
        permission_level = get_user_repo_permission(payload[:repository][:name], user.uid)
        RepoContributor.create(user: user, github_repo: repository, permission_level: permission_level)
      when "edited"
        return if existing_contributor_record.nil?
        existing_contributor_record.permission_level = get_user_repo_permission(payload[:repository][:name], user.uid)
        existing_contributor_record.save
      when "removed"
        existing_contributor_record.try(:destroy)
      else
        return
      end
    end

    def github_team(payload)
      team_info = payload[:team]
      existing_team_record = OrgTeam.find_by_team_id(team_info[:node_id])
      case payload[:action]
      when "created"
        existing_team_record.try(:destroy)
        team = OrgTeam.create(name: team_info[:name], slug: team_info[:slug], url: team_info[:html_url], team_id: team_info[:node_id], course: @course)
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

    def github_membership(payload)
      existing_team_record = OrgTeam.find_by_team_id(payload[:team][:node_id])
      return if existing_team_record.nil?
      case payload[:action]
      when "added"
        add_student_to_team_if_found(existing_team_record, payload)
      when "removed"
        student = @course.student_for_uid(payload[:member][:id])
        return if student.nil?
        StudentTeamMembership.where(roster_student: student, org_team: existing_team_record).first.try(:destroy)
      else
        return
      end
    end

    def github_push(payload)

    end

    private
    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end

    def get_user_repo_permission(repo_name, user_id)
      response = github_machine_user.post '/graphql', { query: user_repo_permission_query(repo_name) }.to_json
      collaborators = response.data.repository.collaborators.edges
      user_collaborator = collaborators.find { |c| c.node.databaseId == user_id }
      return nil if user_collaborator.nil?
      user_collaborator.permission.capitalize
    end

    def user_repo_permission_query(repo_name)
      <<-GRAPHQL
        query { 
          repository(owner:"#{@course.course_organization}",name:"#{repo_name}") {
            collaborators {
              edges {
                permission
                node {
                  databaseId
        } } } } }
      GRAPHQL
    end

    def add_student_to_team_if_found(team, payload)
      student_member = @course.student_for_uid(payload[:member][:id])
      return if student_member.nil?
      response = github_machine_user.post '/graphql', { query: team_member_role_query(team.slug) }.to_json
      team_members = response.data.organization.team.members.edges
      found_member = team_members.find { |m| m.node.databaseId == student_member.user.uid.to_i }
      return if found_member.nil?
      membership = StudentTeamMembership.where(org_team: team, roster_student: student_member).first_or_initialize
      membership.role = found_member.role.downcase
      membership.save
    end

    def team_member_role_query(team_slug)
      <<-GRAPHQL
      query { 
        organization(login:"#{@course.course_organization}") {
          team(slug:"#{team_slug}") {
            members {
              edges {
                role
                node {
                  databaseId
      } } } } } }
      GRAPHQL
    end

    def upsert_team_repo_permissions(team, payload)
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