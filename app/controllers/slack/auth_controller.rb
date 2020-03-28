module Slack
  class AuthController < ApplicationController
    def callback
      @course = Course.find(params[:state])
      if @course.nil?
        redirect_to courses_path, alert: "The course you tried to associate with the Slack workspace could not be found."
        return
      end
      client = Slack::Web::Client.new
      access_token_response = client.oauth_v2_access(
          client_id: ENV['SLACK_CLIENT_ID'],
          client_secret: ENV['SLACK_CLIENT_SECRET'],
          code: params[:code],
          redirect_uri: callback_slack_auth_url
      )
      unless access_token_response.respond_to? :access_token
        redirect_to course_path(@course), alert: "Failed to get access token from Slack. Please try again."
        return
      end
      workspace = SlackWorkspace.new
      workspace.user_access_token = access_token_response[:authed_user][:access_token]
      workspace.bot_access_token = access_token_response[:access_token]
      workspace.name = access_token_response[:team][:name]
      workspace.team_id = access_token_response[:team][:id]
      workspace.app_id = access_token_response[:app_id]
      workspace.scope = access_token_response[:scope]
      workspace.course = @course
      workspace.save
      redirect_to course_slack_path(@course), notice: "Successfully added Slack workspace."
    end
  end
end