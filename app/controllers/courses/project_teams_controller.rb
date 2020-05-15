module Courses
  class ProjectTeamsController < ApplicationController
    load_and_authorize_resource :course

    def index
    end
  end
end