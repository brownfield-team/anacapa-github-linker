module Slack
  class CommandsController < ApplicationController
    # TODO: Set up Slack global request configuration to validate signing secret. We can't check CSRF token, so it's all the more important
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def whois
      authorize! :slack_command, SlackWorkspace
      workspace = SlackWorkspace.find_by_team_id(params[:team_id])
      if workspace.nil?
        render json: { :text => "Associated workspace could not be found in the database." }
        return
      end
      command_text = params[:text]
      # When a user is tagged, it is provided to the command in the form <@U012ABCDEF|worf> or <@U012ABCDEF>
      # This Regex string plucks U012ABCDEF, the user id from the string.
      puts request.to_s
      pluck_user_id_regex = /<@([^|]*)[|>]/
      user_id_matches = command_text.scan(pluck_user_id_regex)
      if user_id_matches.empty?
        render json: { :text => "You must tag a Slack user."}
      else
        command_output = ""
        @students = workspace.course.roster_students.select { |student| student.slack_user.present? }
        user_id_matches.each do |match, index|
          matched_student = @students.find { |student| student.slack_user.uid == match }
          if matched_student.present?
            github_id = matched_student.username
            # Markdown linking to GitHub profile
            github_str = github_id ? "<https://github.com/#{github_id}|#{github_id}>" : "N/A"
            # Markdown linking to student show page
            student_name_str = "<#{course_roster_student_url(workspace.course.id, matched_student.id)}|#{matched_student.full_name}>"
            teams_str = ""
            matched_student.org_teams.each do |team|
              teams_str += "<#{team.url}|#{team.name}>, "
            end
            teams_str.empty? ? teams_str = "N/A" : teams_str.delete_suffix!(", ")
            section_str = matched_student.section
            command_output += "*GitHub ID:* #{github_str}, *Student:* #{student_name_str}, *Section:* #{section_str} *Teams:* #{teams_str}"
          end
        end
        puts "SLACK COMMAND OUTPUT BEFORE EMPTY CHECK"
        puts command_output
        command_output.empty? ? command_output = "No students found for the provided user(s)." : command_output.delete_suffix!("\n")
        render json: { :text => command_output }
      end
    end

  end
end