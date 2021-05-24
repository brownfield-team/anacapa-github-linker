class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :edit, :update, :destroy]
  before_action :set_course

  # GET /courses/:course_id/sprints
  # GET /courses/:course_id/sprints.json
  def index
    @course = Course.find(params[:course_id])
    @sprints = @course.sprints
  end

  # GET /courses/:course_id/sprints/:sprint_id
  # GET /courses/:course_id/:sprint_id.json
  def show
  end

  # GET /sprints/new
  def new
    @sprint = @course.sprints.new
  end

  # GET /sprints/1/edit
  def edit
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = @course.sprints.new(sprint_params)

    respond_to do |format|
      if @sprint.save
        format.html { redirect_to edit_course_path(@course), notice: 'Sprint was successfully created.' }
        format.json { render :show, status: :created, location: edit_course_path(@course) }
      else
        format.html { render :new }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sprints/1
  # PATCH/PUT /sprints/1.json
  def update
    respond_to do |format|
      if @sprint.update(sprint_params)
        format.html { redirect_to edit_course_path(@course), notice: 'Sprint was successfully updated.' }
        format.json { render :show, status: :ok, location: edit_course_path(@course) }
      else
        format.html { render :edit }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html { redirect_to edit_course_path(@course), notice: 'Sprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end
    # Only allow a list of trusted parameters through.
    def sprint_params
      params.require(:sprint).permit(:name, :start_date, :end_date, :course_id)
    end
end