module Courses
  class OrphanCommitsController < ApplicationController
    layout 'courses'
    load_and_authorize_resource :course

    def index
    end

    def by_name
      10.times { puts "********* by name ******************" }
      params.each do |key,value|
        Rails.logger.warn "Param #{key}: #{value}"
      end
      
    end

  end
end