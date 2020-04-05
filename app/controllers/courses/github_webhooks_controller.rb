module Courses
  class GithubWebhooksController < ApplicationController
    include GithubWebhook::Processor
    load_resource :course
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def github_push(payload)

    end

    def verify_signature(payload_body)
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
      return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
  end
end