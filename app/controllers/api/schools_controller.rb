module Api
  class SchoolsController < ApplicationController
    respond_to :json
    load_and_authorize_resource

    def index

    end
  end
end