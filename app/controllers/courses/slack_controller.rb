module Courses
  class SlackController < ApplicationController
    def show
      @parent = Course.find(params[:course_id])
      @workspace = @parent.slack_workspace
    end

    def remove_workspace
      if @workspace.present?
        @workspace.destroy
        redirect_to course_slack_path(@parent), notice: "Workspace successfully removed from course."
      else
        redirect_to course_slack_path(@parent), alert: "Workspace to delete could not be found."
      end
    end

    def callback
      course = Course.find(params[:state])
      if course.nil?
        redirect_to courses_path, alert: "The course you tried to associate with the Slack workspace could not be found."
        return
      end
      client = Slack::Web::Client.new
      access_token_response = client.oauth_access(
          client_id: ENV['SLACK_CLIENT_ID'],
          client_secret: ENV['SLACK_CLIENT_SECRET'],
          code: params[:code]
      )
      unless access_token_response.respond_to? :access_token
        redirect_to course_path(@parent), alert: "Failed to get access token from Slack. Please try again."
        return
      end
      workspace = SlackWorkspace.new
      workspace.access_token = access_token_response[:access_token]
      workspace.bot_access_token = access_token_response[:bot][:bot_access_token]
      workspace.name = access_token_response[:team_name]
      workspace.scope = access_token_response[:scope]
      workspace.save
      course.slack_workspace_id = workspace.id
      course.save
      redirect_to course_slack_path(course), notice: "Successfully added Slack workspace."
    end
  end
end