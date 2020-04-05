module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def github_organization(payload)
      case payload[:action]
      when "member_invited"
      when "member_added"
      when "member_removed"
      when "renamed"
      when "deleted"
      else
        return
      end
    end

    def github_repository(payload)
      case payload[:action]
      when "created"
      when "deleted"
      when "edited"
      when "renamed"
      when "publicized"
      when "privatized"
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