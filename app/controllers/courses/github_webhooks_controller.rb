module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def github_organization(payload)
      case payload[:action]
      when "member_invited"
        student = @course.student_for_username(payload[:invitation][:login])
        return if student.nil?
        student.org_membership_type = "Invited"
        student.save
      when "member_added"
        student = @course.student_for_username(payload[:membership][:user][:login])
        return if student.nil?
        student.is_org_member = true
        student.org_membership_type = payload[:membership][:role].capitalize
        student.save
      when "member_removed"
        student = @course.student_for_username(payload[:membership][:user][:login])
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
        repo_to_delete = GithubRepo.where(course_id: @course.id, repo_id: payload[:repository][:id]).first
        return if repo_to_delete.nil?
        repo_to_delete.destroy
      when "edited"
        # Nothing to do here for now
      when "renamed"
        repo_to_rename = GithubRepo.where(course_id: @course.id, repo_id: payload[:repository][:id]).first
        return if repo_to_rename.nil?
        repo_to_rename.name = payload[:repository][:name]
        repo_to_rename.full_name = payload[:repository][:full_name]
        repo_to_rename.save
      when "publicized"
        repo_to_modify = GithubRepo.where(course_id: @course.id, repo_id: payload[:repository][:id]).first
        repo_to_modify.visibility = "public"
        repo_to_modify.save
      when "privatized"
        repo_to_modify = GithubRepo.where(course_id: @course.id, repo_id: payload[:repository][:id]).first
        repo_to_modify.visibility = "private"
        repo_to_modify.save
      else
        return
      end
    end

    def github_member(payload)
      case payload[:action]
      when "added"
      when "edited"
      when "removed"
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

    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end
  end
end