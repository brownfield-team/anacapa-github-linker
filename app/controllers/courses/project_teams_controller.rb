module Courses
  class ProjectTeamsController < ApplicationController
    layout 'courses'
    load_and_authorize_resource :course

    def index
    end
  end
end