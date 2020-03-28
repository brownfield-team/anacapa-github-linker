module Slack
  class CommandsController < ApplicationController
    # TODO: Set up Slack global request configuration to validate signing secret.
    skip_before_action :authenticate_user!

    def whois
      authorize! :slack_command, SlackWorkspace
      workspace = SlackWorkspace.find_by_team_id(params[:team_id])
      if workspace.nil?
        render json: { :text => "world" }
      end
    end
  end
end