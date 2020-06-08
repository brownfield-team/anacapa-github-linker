module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :record_webhook_event, only: :create

    # TODO: MAKE SURE THIS IS REMOVED BEFORE IT IS MERGED. THIS IS FOR TESTING ONLY.
    skip_before_action :authenticate_github_request!

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
      OrganizationHook.process_hook(@course, payload)
    end

    def github_repository(payload)
      RepositoryHook.process_hook(@course, payload)
    end

    def github_member(payload)
      MemberHook.process_hook(@course, payload)
    end

    def github_team(payload)
      TeamHook.process_hook(@course, payload)
    end

    def github_membership(payload)
      MembershipHook.process_hook(@course, payload)
    end

    def github_push(payload)
      PushHook.process_hook(@course, payload)
    end

    def github_pull_request(payload)
      PullRequestHook.process_hook(@course, payload)
    end

    def github_issues(payload)
      IssuesHook.process_hook(@course, payload)
    end

    private
    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end

  end
end