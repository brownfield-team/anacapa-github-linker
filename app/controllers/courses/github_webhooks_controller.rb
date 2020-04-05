module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

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
      case payload[:action]
      when "created"
      when "deleted"
        repo_to_delete = GithubRepo.where(course: @course, repo_id: payload[:repository][:id]).first
        return if repo_to_delete.nil?
        repo_to_delete.destroy
      when "edited"
        # Nothing to do here for now
      when "renamed"
        repo_to_rename = GithubRepo.where(course: @course, repo_id: payload[:repository][:id]).first
        return if repo_to_rename.nil?
        repo_to_rename.name = payload[:repository][:name]
        repo_to_rename.full_name = payload[:repository][:full_name]
        repo_to_rename.save
      when "publicized"
        repo_to_modify = GithubRepo.where(course: @course, repo_id: payload[:repository][:id]).first
        repo_to_modify.visibility = "public"
        repo_to_modify.save
      when "privatized"
        repo_to_modify = GithubRepo.where(course: @course, repo_id: payload[:repository][:id]).first
        repo_to_modify.visibility = "private"
        repo_to_modify.save
      else
        return
      end
    end

    def github_member(payload)
      user = User.where(uid: payload[:member][:id])
      repository = GithubRepo.where(repo_id: payload[:repository][:id])
      return if user.nil? || repository.nil?
      existing_contributor_record = RepoContributor.where(github_repo: repository, user: user).first
      case payload[:action]
        # GitHub's API has some kind of hilarious prank where this webhook won't give you the user's permission on the repository.
        # The kicker? When you change a user's repo permission it sends a webhook. But that webhook only contains
        # the OLD permission. Meaning: if you change a user's permission from read to write, it'll send you a webhook that basically says
        # "that user used to have read permission". I think there's a quantum superposition joke in here, but I'll have to workshop that some more.
        # Anyway, I filed a bug report but in the meantime I'm just having this webhook make an API request to get the permission level.
      when "added"
        existing_contributor_record.destroy if existing_contributor_record.present?
        permission_level = get_user_repo_permission(payload[:repository][:name], user.uid)
        RepoContributor.create(user: user, github_repo: repository, permission_level: permission_level)
      when "edited"
        return if existing_contributor_record.nil?
        existing_contributor_record.permission_level = get_user_repo_permission(payload[:repository][:name], user.uid)
        existing_contributor_record.save
      when "removed"
        return if existing_contributor_record.nil?
        existing_contributor_record.destroy
      else
        return
      end
    end

    def github_team(payload)
      case payload[:action]
      when "created"
      when "deleted"
      when "edited"
      when "added_to_repository"
      when "removed_from_repository"
      else
        return
      end
    end

    def github_membership(payload)
      case payload[:action]
      when "added"
      when "removed"
      else
        return
      end
    end

    private
    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end

    def get_user_repo_permission(repo_name, user_id)
      response = github_machine_user.post '/graphql', { query: user_repo_permission_query(repo_name) }.to_json
      collaborator = response.data.repository.collaborators.edges
      user_collaborator = contributors.find { |c| c.node.databaseId == user_id }
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
  end
end