module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def github_team(payload)

    end

    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end
  end
end