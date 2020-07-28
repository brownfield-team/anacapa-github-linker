module Octokit_Wrapper
  class Octokit_Wrapper
    def self.machine_user
      user_with(ENV['MACHINE_USER_KEY'])
    end

    def self.session_user(token)
      user_with(token)
    end

    def self.turn_on_octokit_debugging
      # invoke this function before invoking Octokit::Client.new
      # if you want the log output to contain
      # debugging output for Octokit calls
      # See: http://octokit.github.io/octokit.rb/#Debugging

      stack = Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::Retry, exceptions: [Octokit::ServerError]
        builder.use Octokit::Middleware::FollowRedirects
        builder.use Octokit::Response::RaiseError
        builder.use Octokit::Response::FeedParser
        builder.response :logger
        builder.adapter Faraday.default_adapter
      end
      Octokit.middleware = stack
    end

    def self.user_with(token)
      #self.turn_on_octokit_debugging
      
      client = Octokit::Client.new :access_token => token
      client.auto_paginate = true

      client
    end
  end
end