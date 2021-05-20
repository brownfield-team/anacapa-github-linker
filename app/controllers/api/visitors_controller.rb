module Api
  class VisitorsController < ApplicationController
    def index
      @courses = Course.all.where(hidden: false)
    end
  end
end