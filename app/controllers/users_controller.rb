class UsersController < ApplicationController

  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html { }
      format.json {
        @users = User.all
        unless params[:search].nil?
          @users = @users.where("users.name ~* ?", params[:search]).or(User.where("users.username ~* ?", params[:search]))
        end
        unless params[:type].nil?
          @users = User.users_with_role(@users, params[:type])
        end
        paginate json: @users
      }
    end
  end

  def update
    # TODO: Rewrite this update method. It is poorly designed and possible vulnerable to attack.
    @user = User.find(params[:id])
    if params[:commit].include? "Admin"
      @user.change_admin_status
    end
    if params[:commit].include? "Instructor"
      @user.change_instructor_status
    end
    redirect_to users_path
  end


    # private
    #     def user_params
    #         params.require(:user).permit(:roles)
    #     end
end
