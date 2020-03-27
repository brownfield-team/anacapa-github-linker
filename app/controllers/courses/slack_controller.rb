module Courses
  class SlackController < ApplicationController
    def callback
      redirect_to courses_path, alert: "The course you tried to associate with the Slack workspace could not be found."
    end
  end
end