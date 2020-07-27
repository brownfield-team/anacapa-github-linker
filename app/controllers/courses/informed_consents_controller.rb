# This controller is nested in the routing hierarchy as a child controller of 
# courses_controller
# see this tutorial for details on how we do this https://gist.github.com/jhjguxin/3074080

module Courses
  class InformedConsentsController < ApplicationController
    layout 'courses'
    before_action :load_parent
    before_action :set_informed_consent, only: [:show, :edit, :update, :destroy]

    load_and_authorize_resource :course
    load_and_authorize_resource :informed_consent, through: :course

    def index
      @informed_consents = @parent.informed_consents.all

      respond_to do |format|
        format.html
      end
    end

    def import
      if params.has_key? :file
        @parent.import_informed_consents(params[:file], params[:csv_header_map].split(','), params[:csv_header_toggle] == "true")
        redirect_to course_informed_consents_path(@parent), notice: 'Informed Consent information imported.'
      else
        redirect_to course_informed_consents_path(@parent), alert: 'Please specify a file.'
      end
    end

    
    def show
      @informed_consent = @parent.informed_consents.find(params[:id])
    end

    def new
      @informed_consent = @parent.informed_consents.new
    end

    def edit
    end

   
    def create
      @informed_consent = @parent.informed_consents.new(informed_consent_params)
      @informed_consent.roster_student = @parent.roster_students.where(perm: @informed_consent.perm).first

      respond_to do |format|
        if @informed_consent.save
          format.html { redirect_to course_informed_consents_path(@parent), notice: 'Roster student was successfully created.' }
          format.json { render :show, status: :created, location: @informed_consent }
        else
          format.html { render :new }
          format.json { render json: @informed_consent.errors, status: :unprocessable_entity }
        end
      end
    end

    
    def update
      @informed_consent.roster_student = @parent.roster_students.where(perm: @informed_consent.perm).first
      respond_to do |format|
        if @informed_consent.update(informed_consent_params)
          format.html { redirect_to course_informed_consent_path(@parent, @informed_consent), notice: 'Informed Consent record was successfully updated.' }
          format.json { render :show, status: :ok, location: @informed_consent }
        else
          format.html { render :edit }
          format.json { render json: @informed_consent.errors, status: :unprocessable_entity }
        end
      end
    end

    
    def destroy
      @informed_consent.destroy
      respond_to do |format|
        format.html { redirect_to course_informed_consents_path(@parent), notice: 'Informed Consent Record was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_informed_consent
        @informed_consent = InformedConsent.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def informed_consent_params
        params.require(:informed_consent).permit(:perm, :name, :student_consents)
      end

      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end

end
