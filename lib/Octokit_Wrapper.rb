module Octokit_Wrapper
  class Octokit_Wrapper
    def self.machine_user
      user_with(ENV['MACHINE_USER_KEY'])
    end

    def self.session_user(token)
      user_with(token)
    end

    def self.user_with(token)
      client = Octokit::Client.new :access_token => token
      client.auto_paginate = true
      client
    end
  end
end