module Courses
  class OrphanCommitsController < ApplicationController
    layout 'courses'
    load_and_authorize_resource :course

    def index
    end

    def by_name
    end

    def by_email
    end

    def assign_by_name
      roster_student = RosterStudent.find(params[:roster_student_id])
      message = "Assigning orphan name '#{params[:name]}' to roster student #{params[:roster_student_id]} (#{roster_student.full_name}), Fix Orphan Commits Job launched "
      Rails.logger.info message
      on = OrphanName.new(name: params[:name], course:@course, roster_student_id: params[:roster_student_id]).save!
      FixOrphanCommitsJob.perform_async(@course.id)
      redirect_to course_orphan_commits_path(@course), notice: message   
    end

    def assign_by_email
      roster_student = RosterStudent.find(params[:roster_student_id])
      message = "Assigning orphan email '#{params[:email]}' to roster student #{params[:roster_student_id]} (#{roster_student.full_name}), Fix Orphan Commits Job launched "
      Rails.logger.info message
      on = OrphanEmail.new(email: params[:email], course:@course, roster_student_id: params[:roster_student_id]).save!
      FixOrphanCommitsJob.perform_async(@course.id)
      redirect_to course_orphan_commits_path(@course), notice: message   
    end


  end
end